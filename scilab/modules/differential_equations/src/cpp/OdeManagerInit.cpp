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

#include "OdeManager.hxx"
#include "complexHelpers.hxx"

void OdeManager::init()
{
    char errorMsg[256];

    // Complex ode is handled by using [real(y); imag(y)] as state,
    // hence the number of *real* equations is twice the number of complex equatioms
    m_iNbRealEq = m_odeIsComplex ? 2*m_iNbEq : m_iNbEq;

    // Threads or no threads
#ifndef _OPENMP
    m_N_VectorY = N_VNew_Serial(m_iNbRealEq, m_sunctx);
#else
    if (m_iNbThreads > 0)
    {
        m_N_VectorY = N_VNew_OpenMP(m_iNbRealEq, m_iNbThreads, m_sunctx);
        N_VEnableFusedOps_OpenMP(m_N_VectorY, SUNTRUE);
    }
    else
    {
        m_N_VectorY = N_VNew_Serial(m_iNbRealEq, m_sunctx);
    }
#endif
    m_N_VectorYTemp = N_VClone(m_N_VectorY);

    // Load Y0 into N_Serial vector
    // When ODE is complex m_N_VectorY has interlaced real and imaginary part of user Y (equivalent to std::complex)
  
    copyRealImgToComplexVector(m_pDblY0->get(), m_pDblY0->getImg(), N_VGetArrayPointer(m_N_VectorY), m_iNbEq, m_odeIsComplex);

    if (create())
    {
        sprintf(errorMsg,"Solver create error\n");
        throw ast::InternalError(errorMsg);
    }

    if (setUserData(m_prob_mem, (void *)this) < 0)
    {
        sprintf(errorMsg,"setUserData error\n");
        throw ast::InternalError(errorMsg);
    }

    // Eventual initial values of additionnal states are set in initialize() specific solver method
    if (initialize(errorMsg))
    {
        throw ast::InternalError(errorMsg);
    }

    // constraints on solution
    if (m_iVecPositive.size() > 0    ||
        m_iVecNonPositive.size() > 0 ||
        m_iVecNegative.size() > 0    ||
        m_iVecNonNegative.size() > 0)
    {
        N_Vector NVConstr = N_VClone(m_N_VectorY);
        N_VConst(0.0, NVConstr);
        double *pdblConstr = N_VGetArrayPointer(NVConstr);
        for (const auto &it : m_iVecPositive)
        {
           pdblConstr[it-1] = 2;
        }
        for (const auto &it : m_iVecNonNegative)
        {
            pdblConstr[it-1] = 1;
        }
        for (const auto &it : m_iVecNonPositive)
        {
            pdblConstr[it-1] = -1;
        }
        for (const auto &it : m_iVecNegative)
        {
            pdblConstr[it-1] = -2;
        }
        if (setConstraints(m_prob_mem, NVConstr) < 0)
        {
            N_VDestroy(NVConstr);
            sprintf(errorMsg, "setConstraints error");
            throw ast::InternalError(errorMsg);
        }
        N_VDestroy(NVConstr);
    }

    if (m_iMaxNumSteps > 0 && setMaxNumSteps(m_prob_mem, m_iMaxNumSteps))
    {
        sprintf(errorMsg,"setMaxNumSteps error\n");
        throw ast::InternalError(errorMsg);
    }

    if (m_dblInitialStep > 0 && setInitStep(m_prob_mem, m_dblInitialStep) < 0)
    {
        sprintf(errorMsg,"setInitStep error\n");
        throw ast::InternalError(errorMsg);
    }

    if (m_dblMaxStep > 0 && setMaxStep(m_prob_mem, m_dblMaxStep) < 0)
    {
        sprintf(errorMsg,"setMaxStep error\n");
        throw ast::InternalError(errorMsg);
    }

    if (m_dblMinStep > 0 && setMinStep(m_prob_mem, m_dblMinStep) < 0)
    {
        sprintf(errorMsg,"setMinStep error\n");
        throw ast::InternalError(errorMsg);
    }

    // Events
    if (m_iNbEvents > 0 && setEventFunction())
    {
        sprintf(errorMsg,"setEventFunction error\n");
        throw ast::InternalError(errorMsg);
    }
    
    // absolute (a vector) and relative tolerance
    m_N_VectorAtol = N_VClone(m_N_VectorY);
    if (m_odeIsComplex)
    {
        m_dblVecAtol.resize(m_iNbRealEq);
        // loop has to be done backward
        for (int i=m_iNbEq-1; i>=0; i--)
        {
            m_dblVecAtol[2*i] = m_dblVecAtol[i];
            m_dblVecAtol[2*i+1] = m_dblVecAtol[i];
        }
    }
    std::copy(m_dblVecAtol.begin(), m_dblVecAtol.end(), N_VGetArrayPointer(m_N_VectorAtol));

    if (setVTolerances(m_prob_mem, m_dblRtol, m_N_VectorAtol) < 0)
    {
        sprintf(errorMsg,"setTolerances error\n");
        throw ast::InternalError(errorMsg);
    }

    if (hasQuadFeature() && m_bQuadErrCon == true)
    {
        if (setQuadErrCon(m_prob_mem, m_bQuadErrCon) < 0)
        {
            sprintf(errorMsg, "setQuadErrCon error");
            throw ast::InternalError(errorMsg);
        }
        N_Vector m_N_VectorQuadAtol = N_VClone(m_NVectorYQ);
        if (m_odeIsComplex)
        {
            m_dblVecQuadAtol.resize(m_iNbRealQuad);
            // loop has to be done backward
            for (int i=m_iNbQuad-1; i>=0; i--)
            {
                m_dblVecQuadAtol[2*i] = m_dblVecQuadAtol[i];
                m_dblVecQuadAtol[2*i+1] = m_dblVecQuadAtol[i];
            }
        }
        std::copy(m_dblVecQuadAtol.begin(), m_dblVecQuadAtol.end(), N_VGetArrayPointer(m_N_VectorQuadAtol));

        if (setQuadSVTolerances(m_prob_mem, m_dblQuadRtol, m_N_VectorQuadAtol) < 0)
        {
            N_VDestroy(m_N_VectorQuadAtol);
            sprintf(errorMsg,"setQuadSVtolerances error\n");
            throw ast::InternalError(errorMsg);
        }
        N_VDestroy(m_N_VectorQuadAtol);            
    }

    if (setMaxOrd(m_prob_mem, m_iMaxOrder) < 0)
    {
        sprintf(errorMsg,"setMaxOrder error\n");
        throw ast::InternalError(errorMsg);
    }
    //
    // Set linear solver (if applicable) according to Jacobian type (Dense, band or Sparse)
    //
    if (m_wstrNonLinSolver == L"Newton")
    {
        m_wstrLinSolver = setLinearSolver(isDAE() ? JACYYP : JACY, m_N_VectorY, m_A, m_LS);
    }

    if (setSolverAndJacobian(errorMsg))
    {
        throw ast::InternalError(errorMsg);
    }

    if (computeIC(errorMsg))
    {
     throw ast::InternalError(errorMsg);
    }

    if (SUNContext_PushErrHandler(m_sunctx, errHandler, (void *)this) < 0)
    {
        sprintf(errorMsg,"SUNContext_PushErrHandler error\n");
        throw ast::InternalError(errorMsg);
    }
}


