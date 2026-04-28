/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2021 - 2023 - UTC - Stéphane MOTTELET
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include "CVODEManager.hxx"
#include "SUNDIALSBridge.hxx"
#include "odeparameters.hxx"
#include "complexHelpers.hxx"

bool CVODEManager::create()
{
    m_prob_mem = NULL;
 
    if (m_wstrMethod == L"ADAMS")
    {
        m_prob_mem = CVodeCreate(CV_ADAMS, m_sunctx);
    }
    else if (m_wstrMethod == L"BDF")
    {
        m_prob_mem = CVodeCreate(CV_BDF, m_sunctx);
    }

    return m_prob_mem == NULL;
}

std::wstring CVODEManager::getDefaultNonLinSolver()
{
    return m_wstrMethod == L"ADAMS" ? L"fixedPoint" : L"Newton";
}

std::vector<std::wstring> CVODEManager::getAvailableNonLinSolvers()
{
    return {L"Newton", L"fixedPoint"};
}

void CVODEManager::parseMethodAndOrder(types::optional_list &opt)
{
    int iDefaultMaxOrder = 0;
    std::vector<int> emptyVect = {};
    std::wstring wstrDefaultMethod;

    // Projection (feature in CVODES since version 6.2.0)
    parseFunctionFromOption(opt, L"projection", PROJ);
    getBooleanInPlist(getSolverName().c_str(),opt, L"projectError", &m_bErrProj, m_odeIsExtension ? m_prevManager->m_bErrProj : false);

    // stability limit detection
    getBooleanInPlist(getSolverName().c_str(),opt, L"stabLimDet", &m_bStabLimDet, m_odeIsExtension ? m_prevManager->m_bStabLimDet : false);
 
    // ode solver method
    wstrDefaultMethod = m_odeIsExtension ? m_prevManager->m_wstrMethod : getAvailableMethods()[0];
    getStringInPlist(getSolverName().c_str(),opt, L"method", m_wstrMethod, wstrDefaultMethod, getAvailableMethods());
 
    // order
    iDefaultMaxOrder = m_odeIsExtension ? m_prevManager->m_iMaxOrder : getMaxMethodOrder(m_wstrMethod);
    getIntInPlist(getSolverName().c_str(),opt, L"maxOrder", &m_iMaxOrder, iDefaultMaxOrder, {1, getMaxMethodOrder(m_wstrMethod)});

}

bool CVODEManager::initialize(char *errorMsg)
{
    if (CVodeInit(m_prob_mem, rhsFunction, m_dblT0, m_N_VectorY) != CV_SUCCESS)
    {
        sprintf(errorMsg, "CVodeInit error");
        return true;
    }
    // sensitivity
    if (computeSens())
    {
        m_NVArrayYS = N_VCloneVectorArray(getNbSensPar(), m_N_VectorY);
        // copy each column of S(0) in vectors m_NVArrayYS[j], j=0...
        for (int j=0; j<getNbSensPar(); j++)
        {
            copyRealImgToComplexVector(m_pDblYS0->get()+j*m_iNbEq, m_pDblYS0->getImg()+j*m_iNbEq, 
                N_VGetArrayPointer(m_NVArrayYS[j]), m_iNbEq, m_odeIsComplex);
        }
        //initialize solver Sensitivity mode with user provided sensitivity rhs or finite difference mode :
        if (CVodeSensInit(m_prob_mem, getNbSensPar(),
            m_wstrSensCorrStep == L"simultaneous" ? CV_SIMULTANEOUS : CV_STAGGERED,
            m_bHas[SENSRHS] ? sensRhs: NULL,
            m_NVArrayYS) != CV_SUCCESS)
        {
            sprintf(errorMsg, "CVodeSensInit error");
            return true;
        }
        if (m_iVecSensParIndex.size() == 0)
        {
            CVodeSetSensParams(m_prob_mem,  m_pDblSensPar->get(), m_dblVecTypicalPar.data(), NULL);
        }
        else
        {
            for(int& d : m_iVecSensParIndex) d--;
            // CVodeSetSensParams does a copy of array elements of last argument
            CVodeSetSensParams(m_prob_mem,  m_pDblSensPar->get(), m_dblVecTypicalPar.data(), m_iVecSensParIndex.data());
            for(int& d : m_iVecSensParIndex) d++;
        }
        if (CVodeSensEEtolerances(m_prob_mem) != CV_SUCCESS)
        {
            sprintf(errorMsg, "CVodeSensEEtolerances error");
            return true;
        }
        if (CVodeSetSensErrCon(m_prob_mem, m_bSensErrCon) != CV_SUCCESS)
        {
            sprintf(errorMsg, "CVodeSetSensErrCon error");
            return true;
        }

        // there is nothing to do if m_wstrNonLinSolver = L"Newton" as this is the defaut sensitivity solver
        if (m_wstrNonLinSolver == L"fixedPoint")
        {
            /* attach nonlinear solver object to CVode */
            if (m_wstrSensCorrStep == L"simultaneous")
            {
                m_NLSsens = SUNNonlinSol_FixedPointSens(getNbSensPar()+1, m_N_VectorY, 0, m_sunctx);
                if (CVodeSetNonlinearSolverSensSim(m_prob_mem, m_NLSsens) != CV_SUCCESS)
                {
                    sprintf(errorMsg, "CVodeSetNonlinearSolverSensSim error");
                    return true;
                }
            }
            else // CV_STAGGERED
            {
                m_NLSsens = SUNNonlinSol_FixedPointSens(getNbSensPar(), m_N_VectorY, 0, m_sunctx);
                if (CVodeSetNonlinearSolverSensStg(m_prob_mem, m_NLSsens) != CV_SUCCESS)
                {
                    sprintf(errorMsg, "CVodeSetNonlinearSolverSensStg error");
                    return true;
                }
            }
        }
    }
    // pure quadrature variables
    if (m_bHas[QRHS])
    {
        m_iNbQuad = m_iSizeOfInput[QRHS];
        m_iNbRealQuad = m_odeIsComplex ? 2*m_iNbQuad : m_iNbQuad;

        m_NVectorYQ = N_VNew_Serial(m_iNbRealQuad, m_sunctx);

        // Load YQ0 into N_Serial vector
        // When ODE is complex m_NVectorYQ has interlaced real and imaginary part of user YQ0 (equivalent to std::complex)
  
        copyRealImgToComplexVector(m_pDblYQ0->get(), m_pDblYQ0->getImg(), N_VGetArrayPointer(m_NVectorYQ), m_iNbQuad, m_odeIsComplex);

        if (CVodeQuadInit(m_prob_mem, quadratureRhs, m_NVectorYQ) != CV_SUCCESS)
        {
            sprintf(errorMsg, "CVodeQuadInit error");
            return true;
        }

    }
    return false;
}

bool CVODEManager::setSolverAndJacobian(char *errorMsg)
{
    if (m_wstrNonLinSolver == L"Newton")
    {
        if (CVodeSetLinearSolver(m_prob_mem, m_LS, m_A) != CV_SUCCESS)
        {
            sprintf(errorMsg,"CVodeSetLinearSolver error\n");
            return true;
        }
        
        m_NLS = SUNNonlinSol_Newton(m_N_VectorY, m_sunctx);

        if (m_bHas[JACY])
        {
            if (CVodeSetJacFn(m_prob_mem, jacFunction) != CV_SUCCESS)
            {
                sprintf(errorMsg,"CVodeSetJacFn error\n");
                return true;
            }
        }
        else if (m_pIPattern[JACY] != NULL)
        {
            // Jacobian pattern has been provided
            if (CVodeSetJacFn(m_prob_mem, colPackJac) != CV_SUCCESS)
            {
                sprintf(errorMsg,"CVodeSetJacFn error\n");
                throw ast::InternalError(errorMsg);
            }
        }
        else
        {
            if (CVodeSetJacFn(m_prob_mem, NULL) != CV_SUCCESS)
            {
                sprintf(errorMsg,"CVodeSetJacFn error\n");
                return true;
            }
            if (m_wstrLinSolver != L"KLU" && m_wstrLinSolver != L"DENSE" && m_iPrecBand.size()>0)
            {
                CVBandPrecInit(m_prob_mem, m_iNbRealEq, m_iPrecBand[0], m_iPrecBand[1]);
            }
        }
    }
    else
    {
        /* create fixed point nonlinear solver object */
        m_NLS = SUNNonlinSol_FixedPoint(m_N_VectorY, m_iNonLinSolAccel, m_sunctx);
    }

    /* attach nonlinear solver object to CVode */
    if (CVodeSetNonlinearSolver(m_prob_mem, m_NLS) != CV_SUCCESS)
    {
        sprintf(errorMsg,"CVodeSetNonlinearSolver error\n");
        return true;
    }
 
    // // attach projection function
    if (m_bHas[PROJ])
    {
        if (CVodeSetProjFn(m_prob_mem, projFunction) != CV_SUCCESS)
        {
            sprintf(errorMsg,"CVodeSetProjFn error\n");
            return true;
        }
        if (CVodeSetProjErrEst(m_prob_mem, m_bErrProj) != CV_SUCCESS)
        {
            sprintf(errorMsg,"CVodeSetProjErrEst error\n");
            return true;
        }
    }
    
    if (m_bStabLimDet && CVodeSetStabLimDet(m_prob_mem, m_bStabLimDet) != CV_SUCCESS)
    {
        sprintf(errorMsg,"CVodeSetStabLimDet error\n");
        return true;        
    }
    return false;
}

bool CVODEManager::setEventFunction()
{
    if (CVodeRootInit(m_prob_mem, m_iNbEvents, eventFunction) != CV_SUCCESS)
    {
        return true;
    }
    if (m_iVecEventDirection.size() > 0)
    {
        if (CVodeSetRootDirection(m_prob_mem, m_iVecEventDirection.data()) != CV_SUCCESS)
        {
            return true;
        }
    }
    return false;
}

int CVODEManager::getInterpBasisSize()
{
    int iLastOrder;
    CVodeGetLastOrder(m_prob_mem, &iLastOrder);
    return iLastOrder+1;
}

OdeManager::solverReturnCode CVODEManager::doStep(double dblFinalTime, double *pdblTime, solverTaskCode iKind)
{
    std::map<solverTaskCode, int> toCVODETask = {{ODE_ONE_STEP, CV_ONE_STEP}, {ODE_NORMAL, CV_NORMAL}};
 
    int iFlag = CVode(m_prob_mem, dblFinalTime, m_N_VectorY, pdblTime, toCVODETask[iKind]);
    CVodeGetLastOrder(m_prob_mem,&m_iLastOrder);
    return toODEReturn[iFlag];
}


// prepare record vector(s)
void CVODEManager::saveAdditionalStates() 
{
    if (m_odeIsExtension == false)
    {
        if (m_dblT0 == m_pDblTSpan->get(0) || m_iRetCount == 1)
        {
            // sensitivity
            for (int j=0; j<getNbSensPar(); j++)
            {
                m_vecYSOut.push_back(std::vector<double>(N_VGetArrayPointer(m_NVArrayYS[j]),N_VGetArrayPointer(m_NVArrayYS[j]) + m_iNbRealEq));
            }
            // pure quadrature states
            if (m_bHas[QRHS])
            {
                m_vecYQOut.push_back(std::vector<double>(N_VGetArrayPointer(m_NVectorYQ),N_VGetArrayPointer(m_NVectorYQ) + m_iNbRealQuad));
            }
        }
    }
    else
    {
        // new values will be appended to previous ones
        m_vecYSOut = m_prevManager->m_vecYSOut;
        m_vecYSEvent = m_prevManager->m_vecYSEvent;
    } 
}

void CVODEManager::saveAdditionalStates(double dblTime)
{
    if (computeSens())
    {
        CVodeGetSensDky(m_prob_mem, dblTime, 0, m_NVArrayYS);
        for (int j=0; j<getNbSensPar(); j++)
        {
            m_vecYSOut.push_back(std::vector<double>(N_VGetArrayPointer(m_NVArrayYS[j]),N_VGetArrayPointer(m_NVArrayYS[j]) + m_iNbRealEq));
        }        
    }
    if (m_bHas[QRHS]) // pure quadrature variables are integrated
    {
		 CVodeGetQuadDky(m_prob_mem, dblTime, 0, m_NVectorYQ);
         m_vecYQOut.push_back(std::vector<double>(N_VGetArrayPointer(m_NVectorYQ),N_VGetArrayPointer(m_NVectorYQ) + m_iNbRealQuad));
    }
}

void CVODEManager::saveAdditionalEventStates(double dblTime)
{
    if (computeSens())
    {
        CVodeGetSensDky(m_prob_mem, dblTime, 0, m_NVArrayYS);
        for (int j=0; j<getNbSensPar(); j++)
        {
            m_vecYSEvent.push_back(std::vector<double>(N_VGetArrayPointer(m_NVArrayYS[j]),N_VGetArrayPointer(m_NVArrayYS[j]) + m_iNbRealEq));
        }        
    }
}


std::vector<std::pair<std::wstring,types::Double *>> CVODEManager::getAdditionalFields()
{
    std::vector<std::pair<std::wstring,types::Double *>> out;
    if (computeSens())
    {
        out.push_back(std::make_pair(L"s", getYSOut()));
    }
    if (m_bHas[QRHS])
    {
        out.push_back(std::make_pair(L"q", getYQOut()));        
    }
    return out;
}

std::vector<std::pair<std::wstring,types::Double *>> CVODEManager::getAdditionalEventFields()
{
    std::vector<std::pair<std::wstring,types::Double *>> out;
    if (m_iNbEvents > 0 && computeSens())
    {
        out.push_back(std::make_pair(L"se", getYSEvent()));
    }
    return out;
}

void CVODEManager::saveInterpBasisVectors()
{
    CVodeMem cv_mem = (CVodeMem) m_prob_mem;
    // Solution structure output
    // Store current ordrer and Nordsieck History Array
    // N_Vector cv_zn[L_MAX];   Nordsieck array, of size N x (q+1).
    // zn[j] is a vector of length N (j=0,...,q)
    // zn[j] = [1/factorial(j)] * h^j *(jth derivative of the interpolating polynomial)
    // m_indexInterpBasis is the cumulative index later used for solution interpolation
    // m_indexInterpBasis[i] is the column index in whole matrix where NS matrix of timestep i starts.
    m_indexInterpBasis.push_back(m_indexInterpBasis.back()+getInterpBasisSize());

    for (int i=0; i<m_iVecOrder.back()+1; i++)
    {
        std::vector<double> vdblNordsieckVector (N_VGetArrayPointer(cv_mem->cv_zn[i]), N_VGetArrayPointer(cv_mem->cv_zn[i]) + m_iNbRealEq);
        interpBasisVectorList.push_back(vdblNordsieckVector);
    }
}

void CVODEManager::getInterpVectors(double *pdblNS, int iOrderPlusOne, int iIndex, double dblt0, double dblTUser, double dblStep, double *pdblVect, double *pdblVectd)
{
    // pdblNS matrix of Nordsieck vectors not used here (unlike IDA)
    double dblS = (dblTUser-dblt0)/dblStep;
    pdblVect[0] = 1;
    pdblVectd[0] = 0;
    for (int j = 1; j < iOrderPlusOne; j++)
    {
        pdblVectd[j] = pdblVect[j-1]*j/dblStep;
        pdblVect[j] = pdblVect[j-1]*dblS;
    }
}

int CVODEManager::DQJtimes(sunrealtype tt, N_Vector yy, N_Vector yp, N_Vector rr, N_Vector v, N_Vector Jv, sunrealtype c_j, N_Vector work2, N_Vector work3)
{
    CVodeMem cv_mem = (CVodeMem) m_prob_mem;
    CVLsMem cvls_mem = (CVLsMem) cv_mem->cv_lmem;
    
    return cvls_mem->jtimes(v, Jv, tt, yy, yp, m_prob_mem, work2);
}

int CVODEManager::projFunction(sunrealtype t, N_Vector N_VectorY, N_Vector N_VectorCorr, sunrealtype epsProj, N_Vector N_VectorErr, void *pManager)
{
    OdeManager *manager = static_cast<OdeManager *>(pManager);
    functionKind what = PROJ;
    functionAPI fAPI = manager->getFunctionAPI(what);
    double *pdblErr =  N_VectorErr == NULL ? NULL : N_VGetArrayPointer(N_VectorErr);
    
    if (fAPI == SCILAB_CALLABLE)
    {
        types::typed_list in;
        manager->callOpening(what, in, t, N_VGetArrayPointer(N_VectorY), pdblErr);
        if (pdblErr == NULL)
        {
            in.push_back(types::Double::Empty());
        }
        manager->computeFunction(in, what, N_VGetArrayPointer(N_VectorCorr), pdblErr);
    }
    else if (fAPI == SUNDIALS_DLL)
    {
        dynlibFunPtr pFunc = manager->getEntryPointFunction(what);
        ((SUN_DynProj)pFunc)(t, N_VectorY, N_VectorCorr, epsProj, N_VectorErr, manager->getPdblSinglePar(what));
    }
    return 0;
}

int CVODEManager::sensRhs(int Ns, sunrealtype t, N_Vector N_VectorY, N_Vector N_VectorYp, N_Vector *yS, N_Vector *ySdot, void *pManager, N_Vector tmp1, N_Vector tmp2)
{
    // we cannot use computeFunction or computeMatrix methods because sensitivity matrix
    // is given as an array of NVector
    char errorMsg[256];

    OdeManager *manager = static_cast<OdeManager *>(pManager);
    functionKind what = SENSRHS;
    functionAPI fAPI = manager->getFunctionAPI(what);
    int iNbEq = manager->getNEq();
    
    if (fAPI == SCILAB_CALLABLE)
    {
        types::typed_list in;
        types::typed_list out;

        manager->callOpening(what, in, t, N_VGetArrayPointer(N_VectorY));
        // copy each yS[j] in column j of S matrix, j=0...getNbSensPar()-1
        types::Double *pDblS = new types::Double(iNbEq,manager->getNbSensPar(),manager->isComplex());
        for (int j=0; j<manager->getNbSensPar(); j++)
        {
            // pDblS->getImg()+j*m_iNbEq with pDblS->getImg()==NULL is not used when m_odeIsComplex == false !
            copyComplexVectorToDouble(N_VGetArrayPointer(yS[j]), pDblS->get()+j*iNbEq, pDblS->getImg()+j*iNbEq, iNbEq, manager->isComplex());            
        }
        in.push_back(pDblS);
        manager->callClosing(what, in, {1}, out);
        // test if out is a double matrix of correct size then copy in ySdot
        if (out[0]->isDouble() == false)
        {
            sprintf(errorMsg, _("%s: Wrong type for output argument #%d: double expected.\n"), manager->getFunctionName(what), 1);
            throw ast::InternalError(errorMsg);
        }
        types::Double *pDblOut = out[0]->getAs<types::Double>();
        if (pDblOut->getSize() !=  manager->getSizeOfInput(what))
        {
            sprintf(errorMsg, _("%s: Wrong size for output argument #%d: expecting %d.\n"), manager->getFunctionName(what), 1, manager->getSizeOfInput(what));
            throw ast::InternalError(errorMsg);
        }
        // copy each column of S matrix in ySdot[j], j=0...getNbSensPar()-1
        for (int j=0; j<manager->getNbSensPar(); j++)
        {
            copyRealImgToComplexVector(pDblOut->get()+j*iNbEq, pDblOut->getImg()+j*iNbEq, N_VGetArrayPointer(ySdot[j]), iNbEq, manager->isComplex());
        }
        out[0]->DecreaseRef();
        out[0]->killMe();
    }
    else if (fAPI == SUNDIALS_DLL)
    {
        dynlibFunPtr pFunc = manager->getEntryPointFunction(what);
        return ((SUN_DynSensRhs)pFunc)(Ns, t, N_VectorY, N_VectorYp, yS, ySdot, manager->getPdblSinglePar(what), tmp1, tmp2);
    }
    return 0;
}

int CVODEManager::quadratureRhs(sunrealtype t, N_Vector N_VectorY, N_Vector N_VectorYQDot, void *pManager)
{
    return function_t_Y1_Y2(QRHS, t, N_VectorY, N_VectorYQDot, pManager);
}

types::Struct *CVODEManager::getStats()
{
    double dblStat[6] = {0.0,0.0,0.0,0.0,0.0,0.0};
    int qlast;
    int qcur;

    std::wstring fieldNames[15] = {L"nSteps", L"nRhsEvals", L"nRhsEvalsFD", L"nJacEvals", L"nEventEvals",
    L"nLinSolve", L"nRejSteps", L"nNonLiniters", L"nNonLinCVFails", L"order",
    L"hIni", L"hLast", L"hCur", L"tCur", L"eTime"};

    dblStat[4] = m_dblElapsedTime;

    CVodeGetNonlinSolvStats(m_prob_mem, m_incStat+7, m_incStat+8);
    CVodeGetIntegratorStats(m_prob_mem, m_incStat, m_incStat+1, m_incStat+5, m_incStat+6, &qlast, &qcur, dblStat, dblStat+1, dblStat+2, dblStat+3);
    CVodeGetNumGEvals(m_prob_mem, m_incStat+4);
    CVodeGetNumLinSolvSetups(m_prob_mem,m_incStat+5); // CVodeGetIntegratorStats seems broken for nlinsolve(m_incStat+5), hence we do a direct call

    if (m_wstrNonLinSolver == L"Newton")
    {
        CVodeGetNumLinRhsEvals(m_prob_mem, m_incStat+2);
        CVodeGetNumJacEvals(m_prob_mem, m_incStat+3);
    }
    if (computeSens())
    {
        long int li;
        CVodeGetNumRhsEvalsSens(m_prob_mem, &li);
        m_incStat[2] += li;
    }

    // if extending a previous solution, update incremental stats only
    if (m_prevManager != NULL)
    {
        for (int i=0; i<9; i++)
        {
           m_incStat[i] += m_prevManager-> m_incStat[i];
        }
    }
 
    types::Struct *pSt = new types::Struct(1,1);
    for (int i=0; i<9; i++)
    {
        pSt->addField(fieldNames[i].c_str());
        pSt->get(0)->set(fieldNames[i].c_str(),new types::Double((double)m_incStat[i]));
    }

    // order of method for each step
    types::Double *pDblOrder = new types::Double(1, (int) m_iVecOrder.size());
    std::copy(m_iVecOrder.begin(), m_iVecOrder.end(), pDblOrder->get());
    pSt->addField(fieldNames[9].c_str());
    pSt->get(0)->set(fieldNames[9].c_str(), pDblOrder);
 
    for (int i=10; i<15; i++)
    {
        pSt->addField(fieldNames[i].c_str());
        pSt->get(0)->set(fieldNames[i].c_str(), new types::Double(dblStat[i-10]));
    }
    return pSt;
}