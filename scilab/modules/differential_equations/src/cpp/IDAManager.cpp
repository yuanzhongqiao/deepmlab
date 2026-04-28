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

#include "IDAManager.hxx"
#include "SUNDIALSBridge.hxx"
#include "odeparameters.hxx"
#include "complexHelpers.hxx"

bool IDAManager::create()
{
    m_prob_mem = IDACreate(m_sunctx);
    m_N_VectorYp = N_VClone(m_N_VectorY);

    return m_prob_mem == NULL;
}

std::wstring IDAManager::getDefaultNonLinSolver()
{
    return L"Newton";
}

std::vector<std::wstring> IDAManager::getAvailableNonLinSolvers()
{
    return {L"Newton"};
}

void IDAManager::parseMethodAndOrder(types::optional_list &opt)
{
    char errorMsg[256];
    int iDefaultMaxOrder = 0;
    std::vector<int> emptyVect = {};
    std::wstring wstrDefaultMethod;

    // method
    wstrDefaultMethod = m_odeIsExtension ? m_prevManager->m_wstrMethod : getAvailableMethods()[0];
    getStringInPlist(getSolverName().c_str(),opt, L"method", m_wstrMethod, wstrDefaultMethod, getAvailableMethods());

    // order
    iDefaultMaxOrder = m_odeIsExtension ? m_prevManager->m_iMaxOrder : getMaxMethodOrder(m_wstrMethod);
    getIntInPlist(getSolverName().c_str(),opt, L"maxOrder", &m_iMaxOrder, iDefaultMaxOrder, {1, getMaxMethodOrder(m_wstrMethod)});

    // sensitivity
    if (computeSens())
    {
        // initial condition of y' sensitivity (default is zeros(m_iNbEq,getNbSensPar()))
        if (opt.find(L"ypS0") != opt.end())
        {
            if (m_pDblSensPar == NULL)
            {
                sprintf(errorMsg, _("%s: sensitivity parameter \"sensPar\" has not been set.\n"), getSolverName().c_str());
                throw ast::InternalError(errorMsg);         
            }
            if (opt[L"ypS0"]->isDouble())
            {
                types::Double *pDbl = opt[L"ypS0"]->getAs<types::Double>();
                if (pDbl->isComplex() == false && pDbl->getDims()==2 && pDbl->getRows() == m_iNbEq && pDbl->getCols() == getNbSensPar())
                {
                    m_pDblYS0 = pDbl;
                    m_pDblYS0->IncreaseRef();
                    opt.erase(L"ypS0");
                }
            }
            if (m_pDblYS0 == NULL)
            {
                sprintf(errorMsg, _("%s: Wrong type and/or size for option \"ypS0\": a real double matrix of size %d x %d is expected.\n"), 
                    getSolverName().c_str(), m_iNbEq, getNbSensPar());
                throw ast::InternalError(errorMsg);                
            }
        }
        // default zero matrix
        if (m_pDblSensPar != NULL && m_pDblYpS0 == NULL)
        {
            m_pDblYpS0 = new types::Double(m_iNbEq,getNbSensPar());
            m_pDblYpS0->setZeros();
            m_pDblYpS0->IncreaseRef();
        }
    }
}

bool IDAManager::initialize(char *errorMsg)
{
    // Load Yp0 if DAE solver (Y0 is loaded in  OdeManager::init)
    copyRealImgToComplexVector(m_pDblYp0->get(), m_pDblYp0->getImg(), N_VGetArrayPointer(m_N_VectorYp), m_iNbEq, m_odeIsComplex);

    if (IDAInit(m_prob_mem, resFunction, m_dblT0, m_N_VectorY, m_N_VectorYp) != IDA_SUCCESS)
    {
        sprintf(errorMsg,"IDAInit error.");
    }
    // sensitivity
    if (computeSens())
    {
        m_NVArrayYS = N_VCloneVectorArray(getNbSensPar(), m_N_VectorY);
        m_NVArrayYpS = N_VCloneVectorArray(getNbSensPar(), m_N_VectorY);
        // copy each column of S(0), S'(0) in vectors m_NVArrayYS[j],  m_NVArrayYpS[j], j=0...
        for (int j=0; j<getNbSensPar(); j++)
        {
            copyRealImgToComplexVector(m_pDblYS0->get()+j*m_iNbEq, m_pDblYS0->getImg()+j*m_iNbEq, 
                N_VGetArrayPointer(m_NVArrayYS[j]), m_iNbEq, m_odeIsComplex);
            copyRealImgToComplexVector(m_pDblYpS0->get()+j*m_iNbEq, m_pDblYpS0->getImg()+j*m_iNbEq, 
                N_VGetArrayPointer(m_NVArrayYpS[j]), m_iNbEq, m_odeIsComplex);
        }

        //initialize solver Sensitivity mode with user provided sensitivity rhs or finite difference mode :
        if (IDASensInit(m_prob_mem, getNbSensPar(),
            m_wstrSensCorrStep == L"simultaneous" ? IDA_SIMULTANEOUS : IDA_STAGGERED,
            m_bHas[SENSRES] ? sensRes : NULL,
            m_NVArrayYS,
            m_NVArrayYpS) != IDA_SUCCESS)
        {
            sprintf(errorMsg, "IDASensInit error");
            return true;
        }
        if (m_iVecSensParIndex.size() == 0)
        {
            IDASetSensParams(m_prob_mem,  m_pDblSensPar->get(), m_dblVecTypicalPar.data(), NULL);
        }
        else
        {
            // change Scilab 1-based indexes to 0-based
            for(int& d : m_iVecSensParIndex) d--;
            // CVodeSetSensParams does a copy of array elements of last argument
            IDASetSensParams(m_prob_mem,  m_pDblSensPar->get(), m_dblVecTypicalPar.data(), m_iVecSensParIndex.data());
            // restore indexes
            for(int& d : m_iVecSensParIndex) d++;
        }
        if (IDASensEEtolerances(m_prob_mem) != IDA_SUCCESS)
        {
            sprintf(errorMsg, "IDASensEEtolerances error");
            return true;
        }
        if (IDASetSensErrCon(m_prob_mem, m_bSensErrCon) != IDA_SUCCESS)
        {
            sprintf(errorMsg, "IDASetSensErrCon error");
            return true;
        }

        // there is nothing about non linear sensitivity solver as Newton is the only available in IDA
        // and we do not provide an alternative. 

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

        if (IDAQuadInit(m_prob_mem, quadratureRhs, m_NVectorYQ) != IDA_SUCCESS)
        {
            sprintf(errorMsg, "IDAQuadInit error");
            return true;
        }
    }
    
    return false;
}

bool IDAManager::computeIC(char *errorMsg)
{
    // setting algebraic components ids can be necessary
    // independently of calcIC option value
    N_Vector id = N_VClone(m_N_VectorY);
    // 1 means differential state (derivative appears explicitely in the residual)
    std::fill(N_VGetArrayPointer(id), N_VGetArrayPointer(id)+m_iNbRealEq, 1);
    for (auto index : m_iVecIsAlgebraic)
    {
        // 0 means algebraic state (derivative does not appear explicitely in the residual)
        N_VGetArrayPointer(id)[index-1] = 0;
        if (m_odeIsComplex)
        {
            N_VGetArrayPointer(id)[index-1+m_iNbEq] = 0; // 0 means algebraic state
        }
    }        
    if  (IDASetId(m_prob_mem, id) != IDA_SUCCESS)
    {
        sprintf(errorMsg,"IDASetId error\n");
        return true;
    }
    if (m_iVecIsAlgebraic.size() > 0)
    {
        IDASetSuppressAlg(m_prob_mem, m_bSuppressAlg);
    }
    // compute initial condition, if applicable

    if (m_wstrCalcIc == L"y0yp0")
    {
        // Compute yp0 and algebraic components of y0 given differential components of y0
        long int iFlag = IDACalcIC(m_prob_mem, IDA_YA_YDP_INIT, m_pDblTSpan->get(m_pDblTSpan->getSize()-1));

        if (iFlag != IDA_SUCCESS)
        {
            sprintf(errorMsg,"IDACalcIC error : %s\n", IDAGetReturnFlagName(iFlag));
            return true;
        }
        // recover corrected initial conditions
        if (IDAGetConsistentIC(m_prob_mem, m_N_VectorY, m_N_VectorYp) != IDA_SUCCESS)
        {
            sprintf(errorMsg,"IDAGetConsistentIC error\n");
            return true;
        }
        // If sensitivity computation is enabled, recover corrected sensitivity initial conditions
        if (computeSens())
        {
            if (IDAGetSensConsistentIC(m_prob_mem, m_NVArrayYS, m_NVArrayYpS) != IDA_SUCCESS)
            {
                sprintf(errorMsg,"IDAGetSensConsistentIC error\n");
                return true;
            }            
        }
    }
    else if (m_wstrCalcIc == L"y0")
    {
        // Compute y0 given yp0
        long int iFlag = IDACalcIC(m_prob_mem, IDA_Y_INIT, m_pDblTSpan->get(m_pDblTSpan->getSize()-1));
        if (iFlag != IDA_SUCCESS)
        {
            sprintf(errorMsg,"IDACalcIC error : %s\n", IDAGetReturnFlagName(iFlag));
            return true;
        }
        // recover corrected initial conditions
        if (IDAGetConsistentIC(m_prob_mem, m_N_VectorY, m_N_VectorYp) != IDA_SUCCESS)
        {
            sprintf(errorMsg,"IDAGetConsistentIC error\n");
            return true;
        }
        // If sensitivity computation is enabled, recover corrected sensitivity initial conditions
        if (computeSens())
        {
            if (IDAGetSensConsistentIC(m_prob_mem, m_NVArrayYS, m_NVArrayYpS) != IDA_SUCCESS)
            {
                sprintf(errorMsg,"IDAGetSensConsistentIC error\n");
                return true;
            }            
        }
    }

    return false;
}

bool IDAManager::setSolverAndJacobian(char *errorMsg)
{
    /* Attach the matrix and linear solver */
    if (IDASetLinearSolver(m_prob_mem, m_LS, m_A) != IDA_SUCCESS)
    {
         sprintf(errorMsg,"IDASetLinearSolver error\n");
         return true;
    }
    
    if (m_bHas[JACYYP])
    {
        if (IDASetJacFn(m_prob_mem, jacResFunction) != IDA_SUCCESS)
        {
            sprintf(errorMsg,"IDASetJacFn error\n");
            return true;
        }
        if (m_pIConstFunction[JACY] != NULL)
        {
            // Constant Jacobians case: clone Jacobian template m_A as m_TempSUNMat
            m_TempSUNMat = SUNMatClone(m_A);
            // then copy the constant dR/dy to m_TempSUNMat
            copyMatrixToSUNMatrix(m_pIConstFunction[JACY], m_TempSUNMat, m_iNbEq, m_odeIsComplex);
        }
    }
    else if (m_pIPattern[JACYYP] != NULL)
    {
        // Jacobian pattern has been provided
        if (IDASetJacFn(m_prob_mem, colPackJac) != IDA_SUCCESS)
        {
            sprintf(errorMsg,"IDASetJacFn error\n");
            throw ast::InternalError(errorMsg);
        }
    }

    return false;
}

int IDAManager::colPackJac(sunrealtype t, sunrealtype c, N_Vector N_VectorY, N_Vector N_VectorYp, N_Vector N_VectorR, SUNMatrix SUNMat_J, void *pManager, 
    N_Vector tmp1, N_Vector tmp2, N_Vector tmp3)
{
    return SUNDIALSManager::colPackJac(t, c, N_VectorY, N_VectorYp, N_VectorR, SUNMat_J, pManager, tmp1, tmp2, tmp3);
}

bool IDAManager::setEventFunction()
{
    if (IDARootInit(m_prob_mem, m_iNbEvents, eventFunctionImpl) != IDA_SUCCESS)
    {
        return true;
    }
    if (m_iVecEventDirection.size() > 0)
    {
        if (IDASetRootDirection(m_prob_mem, m_iVecEventDirection.data()) != IDA_SUCCESS)
        {
            return true;
        }
    }
    return false;
}

int IDAManager::getInterpBasisSize()
{
    int iLastOrder;
    IDAGetLastOrder(m_prob_mem, &iLastOrder);
    return iLastOrder+1;
}


// Stepper function
OdeManager::solverReturnCode IDAManager::doStep(double dblFinalTime, double *pdblTime, solverTaskCode iKind)
{
    std::map<solverTaskCode, int> toIDATask = {{ODE_ONE_STEP, IDA_ONE_STEP}, {ODE_NORMAL, IDA_NORMAL}};
    
    int iFlag = IDASolve(m_prob_mem, dblFinalTime, pdblTime, m_N_VectorY, m_N_VectorYp, toIDATask[iKind]);
    IDAGetLastOrder(m_prob_mem,&m_iLastOrder);
    
    return toODEReturn[iFlag];
}


// prepare record vector(s)
void IDAManager::saveAdditionalStates()    
{
    if (m_odeIsExtension == false)
    {
        if (m_dblT0 == m_pDblTSpan->get(0) || m_iRetCount == 1)
        {
            // copy actual Yp because it may have been modified by calcIC
            m_vecYpOut.push_back(std::vector<double>(N_VGetArrayPointer(m_N_VectorYp),N_VGetArrayPointer(m_N_VectorYp) + m_iNbRealEq));

            // sensitivity
            for (int j=0; j<getNbSensPar(); j++)
            {
                m_vecYSOut.push_back(std::vector<double>(N_VGetArrayPointer(m_NVArrayYS[j]),N_VGetArrayPointer(m_NVArrayYS[j]) + m_iNbRealEq));
                m_vecYpSOut.push_back(std::vector<double>(N_VGetArrayPointer(m_NVArrayYpS[j]),N_VGetArrayPointer(m_NVArrayYpS[j]) + m_iNbRealEq));
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
        m_vecYpOut = m_prevManager->m_vecYpOut;
        m_vecYpEvent = m_prevManager->m_vecYpEvent;
        m_vecYpSOut = m_prevManager->m_vecYpSOut;
        m_vecYpSEvent = m_prevManager->m_vecYpSEvent;
    }
}

void IDAManager::saveAdditionalStates(double dblTime)
{
    // derivative y'
    IDAGetDky(m_prob_mem, dblTime, 1, m_N_VectorYTemp);
    m_vecYpOut.push_back(std::vector<double>(N_VGetArrayPointer(m_N_VectorYTemp), N_VGetArrayPointer(m_N_VectorYTemp) + m_iNbRealEq));
    if (computeSens())
    {
        // sensitivity of y
        IDAGetSensDky(m_prob_mem, dblTime, 0, m_NVArrayYS);
        for (int j=0; j<getNbSensPar(); j++)
        {
            m_vecYSOut.push_back(std::vector<double>(N_VGetArrayPointer(m_NVArrayYS[j]),N_VGetArrayPointer(m_NVArrayYS[j]) + m_iNbRealEq));
        }
        // sensitivity of y'
        IDAGetSensDky(m_prob_mem, dblTime, 1, m_NVArrayYpS);
        for (int j=0; j<getNbSensPar(); j++)
        {
            m_vecYpSOut.push_back(std::vector<double>(N_VGetArrayPointer(m_NVArrayYpS[j]),N_VGetArrayPointer(m_NVArrayYpS[j]) + m_iNbRealEq));
        }        
    }
    if (m_bHas[QRHS]) // pure quadrature variables are integrated
    {
		 IDAGetQuadDky(m_prob_mem, dblTime, 0, m_NVectorYQ);
         m_vecYQOut.push_back(std::vector<double>(N_VGetArrayPointer(m_NVectorYQ),N_VGetArrayPointer(m_NVectorYQ) + m_iNbRealQuad));
    }
}

void IDAManager::saveAdditionalEventStates(double dblTime)
{
    IDAGetDky(m_prob_mem, dblTime, 1, m_N_VectorYTemp);
    m_vecYpEvent.push_back(std::vector<double>(N_VGetArrayPointer(m_N_VectorYTemp), N_VGetArrayPointer(m_N_VectorYTemp) + m_iNbRealEq));
    if (computeSens())
    {
        IDAGetSensDky(m_prob_mem, dblTime, 0, m_NVArrayYS);
        for (int j=0; j<getNbSensPar(); j++)
        {
            m_vecYSEvent.push_back(std::vector<double>(N_VGetArrayPointer(m_NVArrayYS[j]),N_VGetArrayPointer(m_NVArrayYS[j]) + m_iNbRealEq));
        }        
        IDAGetSensDky(m_prob_mem, dblTime, 1, m_NVArrayYS);
        for (int j=0; j<getNbSensPar(); j++)
        {
            m_vecYpSEvent.push_back(std::vector<double>(N_VGetArrayPointer(m_NVArrayYpS[j]),N_VGetArrayPointer(m_NVArrayYpS[j]) + m_iNbRealEq));
        }        
    }
}


std::vector<std::pair<std::wstring,types::Double *>> IDAManager::getAdditionalFields()
{
    std::vector<std::pair<std::wstring,types::Double *>> out;
    out.push_back(std::make_pair(L"yp", getYpOut()));
    if (computeSens())
    {
        out.push_back(std::make_pair(L"s", getYSOut()));
        out.push_back(std::make_pair(L"sp", getYpSOut()));
    }
    if (m_bHas[QRHS])
    {
        out.push_back(std::make_pair(L"q", getYQOut()));        
    }
    return out;
}

std::vector<std::pair<std::wstring,types::Double *>> IDAManager::getAdditionalEventFields()
{
    std::vector<std::pair<std::wstring,types::Double *>> out;
    if (m_iNbEvents > 0)
    {
        out.push_back(std::make_pair(L"ype", getYpEvent()));
        if (computeSens())
        {
            out.push_back(std::make_pair(L"se", getYSEvent()));            
            out.push_back(std::make_pair(L"spe", getYpSEvent()));            
        }
    }
    return out;
}

void IDAManager::saveInterpBasisVectors()
{
    IDAMem ida_mem = (IDAMem) m_prob_mem;
    m_indexInterpBasis.push_back(m_indexInterpBasis.back()+getInterpBasisSize());

    for (int i=0; i<m_iVecOrder.back()+1; i++)
    {
        std::vector<double> vdblPhiVector (N_VGetArrayPointer(ida_mem->ida_phi[i]), N_VGetArrayPointer(ida_mem->ida_phi[i]) + m_iNbRealEq);
        // add scalar psi[i] at the end of vector phi[i]
        vdblPhiVector.push_back(ida_mem->ida_psi[i]);
        interpBasisVectorList.push_back(vdblPhiVector);
    }
}

void IDAManager::getInterpVectors(double *pdblNS, int iOrderPlusOne, int iIndex, double dblt0, double dblTUser, double dblStep, double *pdblVect, double *pdblVectd)
{
    double dblGamma = 0;
    double dblDelta = dblTUser-dblt0;
    double *pdblPsi = pdblNS + m_iNbRealEq; // psi[0] is the last value of first column (above lines are components of phi0)
    double psi_jm1 = *pdblPsi; // psi[0]
    double psi_j = 0; // psi0

    // code is adapted from IDAGetSolution(() in SUNDIALS ida.c
    dblGamma = dblDelta/psi_jm1;
    pdblVect[0] = 1;
    pdblVectd[0] = 0;
    for (int j = 1; j < iOrderPlusOne; j++)
    {
        pdblVectd[j] = pdblVectd[j-1]*dblGamma + pdblVect[j-1]/psi_jm1;
        pdblVect[j] = pdblVect[j-1]*dblGamma;
        pdblPsi += m_iNbRealEq+1; // NS matrix has m_nbRealEq+1 lines, psi[j] is last element of column j
        psi_j = *pdblPsi;
        dblGamma = (dblDelta + psi_jm1) / psi_j;
        psi_jm1 = psi_j;
    }
}

int IDAManager::DQJtimes(sunrealtype tt, N_Vector yy, N_Vector yp, N_Vector rr, N_Vector v, N_Vector Jv, sunrealtype c_j, N_Vector work2, N_Vector work3)
{
	IDAMem ida_mem = (IDAMem) m_prob_mem;
	IDALsMem idals_mem = (IDALsMem) ida_mem->ida_lmem;

    return idals_mem->jtimes(tt, yy, yp, rr, v, Jv, c_j, m_prob_mem, work2, work3);
}


int IDAManager::sensRes(int Ns, sunrealtype t, N_Vector N_VectorY, N_Vector N_VectorYp, N_Vector resval, N_Vector *yS, N_Vector *ySdot,  N_Vector *resvalS,
    void *pManager, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3)
{
    // This function computes the sensitivity residual for all sensitivity equation
    // see https://sundials.readthedocs.io/en/latest/idas/Usage/FSA.html#c.IDASensResFn
    //
    // We cannot use computeFunction or computeMatrix methods because sensitivities of y and y ' are  given as arrays of NVectors
    char errorMsg[256];

    OdeManager *manager = static_cast<OdeManager *>(pManager);
    functionKind what = SENSRES;
    functionAPI fAPI = manager->getFunctionAPI(what);
    int iNbEq = manager->getNEq();
    
    if (fAPI == SCILAB_CALLABLE)
    {
        types::typed_list in;
        types::typed_list out;

        manager->callOpening(what, in, t, N_VGetArrayPointer(N_VectorY),  N_VGetArrayPointer(N_VectorYp));

        // copy each yS[j] in column j of YS matrix, j=0...getNbSensPar()-1
        // then add YS on the argument stack
        types::Double *pDblYS = new types::Double(iNbEq,manager->getNbSensPar(),manager->isComplex());
        for (int j=0; j<manager->getNbSensPar(); j++)
        {
            // pDblS->getImg()+j*m_iNbEq with pDblS->getImg()==NULL is not used when m_odeIsComplex == false !
            copyComplexVectorToDouble(N_VGetArrayPointer(yS[j]), pDblYS->get()+j*iNbEq, pDblYS->getImg()+j*iNbEq, iNbEq, manager->isComplex());            
        }
        in.push_back(pDblYS);

        // copy each ySdot[j] in column j of YpS matrix, j=0...getNbSensPar()-1
        // then add YpS on the argument stack
        types::Double *pDblYpS = new types::Double(iNbEq,manager->getNbSensPar(),manager->isComplex());
        for (int j=0; j<manager->getNbSensPar(); j++)
        {
            // pDblS->getImg()+j*m_iNbEq with pDblS->getImg()==NULL is not used when m_odeIsComplex == false !
            copyComplexVectorToDouble(N_VGetArrayPointer(ySdot[j]), pDblYpS->get()+j*iNbEq, pDblYpS->getImg()+j*iNbEq, iNbEq, manager->isComplex());            
        }
        in.push_back(pDblYpS);

        manager->callClosing(what, in, {1}, out);
        // test if out is a double matrix of correct size then copy in resvalS
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
        // copy each column of residual matrix in resvalS[j], j=0...getNbSensPar()-1
        for (int j=0; j<manager->getNbSensPar(); j++)
        {
            copyRealImgToComplexVector(pDblOut->get()+j*iNbEq, pDblOut->getImg()+j*iNbEq, N_VGetArrayPointer(resvalS[j]), iNbEq, manager->isComplex());
        }
        out[0]->DecreaseRef();
        out[0]->killMe();
    }
    else if (fAPI == SUNDIALS_DLL)
    {
        dynlibFunPtr pFunc = manager->getEntryPointFunction(what);
        return ((SUN_DynSensRes)pFunc)(Ns, t, N_VectorY, N_VectorYp, resval, yS, ySdot, resvalS, manager->getPdblSinglePar(what), tmp1, tmp2, tmp3);
    }
    return 0;
}

int IDAManager::quadratureRhs(sunrealtype t, N_Vector N_VectorY,  N_Vector N_VectorYp, N_Vector N_VectorYQDot, void *pManager)
{
    return function_t_Y1_Y2_Y3(QRHS, t, N_VectorY, N_VectorYp, N_VectorYQDot, pManager);
}

types::Struct *IDAManager::getStats()
{
    double dblStat[6] = {0.0,0.0,0.0,0.0,0.0,0.0};
    int qlast;
    int qcur;

    std::wstring fieldNames[15] = {L"nSteps", L"nRhsEvals", L"nRhsEvalsFD", L"nJacEvals", L"nEventEvals",
    L"nLinSolve", L"nRejSteps", L"nNonLiniters", L"nNonLinCVFails", L"order",
    L"hIni", L"hLast", L"hCur", L"tCur", L"eTime"};

    IDAGetNonlinSolvStats(m_prob_mem, m_incStat+7, m_incStat+8);
    IDAGetIntegratorStats(m_prob_mem, m_incStat, m_incStat+1, m_incStat+5, m_incStat+6, &qlast, &qcur, dblStat, dblStat+1, dblStat+2, dblStat+3);
    dblStat[4] = m_dblElapsedTime;
    IDAGetNumGEvals(m_prob_mem, m_incStat+4);
    IDAGetNumLinSolvSetups(m_prob_mem,m_incStat+5); // IDAGetIntegratorStats seems broken for nlinsolve(m_incStat+5), hence we do a direct call
    IDAGetNumLinResEvals(m_prob_mem, m_incStat+2);
    IDAGetNumJacEvals(m_prob_mem, m_incStat+3);

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
    types::Double *pDblOrder = new types::Double(1,m_iVecOrder.size());
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