//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2021-2022 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

#ifndef _CVODEMANAGER_HXX_
#define _CVODEMANAGER_HXX_

#include "dynlib_differential_equations.h"

#include "OdeManager.hxx"

#include <cvodes/cvodes_impl.h>
#include <cvodes/cvodes_ls_impl.h>
#include <cvodes/cvodes.h>            /* prototypes for CVODE fcts. and consts. */
#include <cvodes/cvodes_proj.h>
#include <cvodes/cvodes_bandpre.h>

extern "C"
{
    int SUN_dynrhs(sunrealtype t, N_Vector Y, N_Vector Yd, void *user_data);
    int SUN_dynrhspar(sunrealtype t, N_Vector Y, N_Vector Yd, void *user_data);
    int SUN_dynjac(sunrealtype t, N_Vector Y, N_Vector Yd, SUNMatrix J, void *user_data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3);
    int SUN_dynjacpar(sunrealtype t, N_Vector Y, N_Vector Yd, SUNMatrix J, void *user_data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3);
    int SUN_dyncb(sunrealtype t, int iFlag, N_Vector N_VectorY, void *user_data);
    int SUN_dynevent(sunrealtype t, N_Vector Y, sunrealtype *gout, void *user_data);
    int SUN_dyneventpar(sunrealtype t, N_Vector Y, sunrealtype *gout, void *user_data);
}

typedef void(*dynlibFunPtr)();

class DIFFERENTIAL_EQUATIONS_IMPEXP CVODEManager final : public OdeManager
{
public :

    CVODEManager()
    {
        m_strSolver = "cvode";
        m_wstrSolver = L"cvode";
        m_staticFunctionMap[L"SUN_dynrhs"] = (dynlibFunPtr)SUN_dynrhs;
        m_staticFunctionMap[L"SUN_dynrhspar"] = (dynlibFunPtr)SUN_dynrhspar;
        m_staticFunctionMap[L"SUN_dynjac"] = (dynlibFunPtr)SUN_dynjac;
        m_staticFunctionMap[L"SUN_dynjacpar"] = (dynlibFunPtr)SUN_dynjacpar;
        m_staticFunctionMap[L"SUN_dyncb"] = (dynlibFunPtr)SUN_dyncb;
        m_staticFunctionMap[L"SUN_dynevent"] = (dynlibFunPtr)SUN_dynevent;
        m_staticFunctionMap[L"SUN_dyneventpar"] = (dynlibFunPtr)SUN_dyneventpar;

        setUserData = CVodeSetUserData;
        setInitStep = CVodeSetInitStep;
        setMinStep = CVodeSetMinStep;
        setMaxStep = CVodeSetMaxStep;
        setMaxNumSteps = CVodeSetMaxNumSteps;
        setStopTime = CVodeSetStopTime;
        setMaxOrd = CVodeSetMaxOrd;
        getCurrentTime = CVodeGetCurrentTime;
        getCurrentStep = CVodeGetCurrentStep;
        getLastStep = CVodeGetLastStep;
        getRootInfo = CVodeGetRootInfo;
        setConstraints = CVodeSetConstraints;
        setVTolerances = CVodeSVtolerances;
        setQuadSVTolerances = CVodeQuadSVtolerances;
        setQuadErrCon = CVodeSetQuadErrCon;
        getReturnFlagName = CVodeGetReturnFlagName;
        getDky = CVodeGetDky;
        // getSens = CVodeGetSens;
        // getSensDky = CVodeGetSensDky;

        toODEReturn.emplace(CV_SUCCESS, ODE_SUCCESS);
        toODEReturn.emplace(CV_TSTOP_RETURN, ODE_TSTOP_RETURN);
        toODEReturn.emplace(CV_ROOT_RETURN, ODE_ROOT_RETURN);
        toODEReturn.emplace(CV_CONV_FAILURE, ODE_CONV_FAILURE);
        toODEReturn.emplace(CV_TOO_MUCH_WORK, ODE_TOO_MUCH_WORK);
        toODEReturn.emplace(CV_REPTD_RHSFUNC_ERR, ODE_REPTD_RHSFUNC_ERR);
        toODEReturn.emplace(CV_WARNING, ODE_WARNING);

        fromODEReturn.emplace(ODE_SUCCESS, CV_SUCCESS);
        fromODEReturn.emplace(ODE_TSTOP_RETURN, CV_TSTOP_RETURN );
        fromODEReturn.emplace(ODE_ROOT_RETURN, CV_ROOT_RETURN);
        fromODEReturn.emplace(ODE_CONV_FAILURE, CV_CONV_FAILURE);
        fromODEReturn.emplace(ODE_TOO_MUCH_WORK, CV_TOO_MUCH_WORK);
        fromODEReturn.emplace(ODE_REPTD_RHSFUNC_ERR, CV_REPTD_RHSFUNC_ERR);
        fromODEReturn.emplace(ODE_WARNING, CV_WARNING);
    }

    ~CVODEManager()
    {
        if (m_prob_mem != NULL)
        {
            CVodeFree(&m_prob_mem);
        }
        m_prob_mem = NULL;
        if (m_NVArrayYS != NULL)
        {
            for (int i=0; i<getNbSensPar(); i++)
            {
                N_VDestroy(m_NVArrayYS[i]);
            }
            //N_VDestroyVectorArray_Serial(m_NVArrayYS, getNbSensPar());
            m_NVArrayYS = NULL;
        }
        if (m_NVectorYQ != NULL)
        {
            N_VDestroy(m_NVectorYQ);
        }
        SUNDIALSMANAGER_KILLME(m_pDblSensPar);
        SUNDIALSMANAGER_KILLME(m_pDblYS0);
        SUNDIALSMANAGER_KILLME(m_pDblYQ0);
    };

    OdeManager *getPreviousManager()
    {
        return m_prevManager;
    }

    void setPreviousManager(void *p)
    {
        m_prevManager = static_cast<CVODEManager *>(p);
        m_odeIsExtension = true;
    }

    virtual bool isODE()
    {
        return true;
    }

    types::Double *getYSOut()
    {
        // sensitivity at user prescribed timesteps or at each internal step of the method
        return getArrayFromVectors(m_pDblYS0, m_vecYSOut, m_dblVecTOut.size());
    }

    types::Double *getYQOut()
    {
        // pure quadrature variable at user prescribed timesteps or at each internal step of the method
        return getArrayFromVectors(m_pDblYQ0, m_vecYQOut, m_dblVecTOut.size());
    }

    types::Double *getYSEvent()
    {
        return getArrayFromVectors(m_pDblYS0, m_vecYSEvent, m_dblVecEventTime.size());
    }

    std::vector<std::pair<std::wstring,types::Double *>> getAdditionalFields();
    std::vector<std::pair<std::wstring,types::Double *>> getAdditionalEventFields();
    void saveAdditionalStates();
    void saveAdditionalStates(double dblTime);
    void saveAdditionalEventStates(double dblTime);

    void parseMethodAndOrder(types::optional_list &opt);
    std::wstring getDefaultNonLinSolver();
    std::vector<std::wstring> getAvailableNonLinSolvers();
    bool create();
    bool initialize(char *);
    // void errHandler(int error_code, const char *module, const char *function, char *msg);
    bool setMaxOrder();
    bool setEventFunction();
    bool setSolverAndJacobian(char *errorMsg);
    int getInterpBasisSize();
    solverReturnCode doStep(double dblFinalTime, double *pdblTime, solverTaskCode iKind);
    void saveInterpBasisVectors();
    void getInterpVectors(double *pdblNS, int iOrderPlusOne, int iIndex, double dblt0, double dblTUser, double dblStep, double *pdblVect, double *pdblVectd);
    bool initSensitivity(char *errorMsg);

    int DQJtimes(sunrealtype tt, N_Vector yy, N_Vector yp, N_Vector rr,
                  N_Vector v, N_Vector Jv, sunrealtype c_j,
                  N_Vector work1, N_Vector work2) final;

    // static methods
    static int sensRhs(int Ns, sunrealtype t, N_Vector N_VectorY, N_Vector N_VectorYp, N_Vector *yS, N_Vector *ySdot, void *pManager,
        N_Vector tmp1, N_Vector tmp2);
    static int quadratureRhs(sunrealtype t, N_Vector N_VectorY, N_Vector N_VectorYQDot, void *pManager);
    static int projFunction(sunrealtype t, N_Vector N_VectorY, N_Vector N_VectorCorr, sunrealtype epsProj, N_Vector N_VectorErr, void *pManager);

    types::Struct *getStats();

    std::vector<std::wstring> getAvailableMethods()
    {
        std::vector<std::wstring> availableMethods = {};
        if (hasJacobian() == false && m_bHas[PROJ] == false)
        {
            availableMethods.push_back(L"ADAMS")  ;
        }
        availableMethods.push_back(L"BDF");
        return availableMethods;
    }

    int getMaxMethodOrder(std::wstring wstrMethod)
    {
        return wstrMethod == L"ADAMS" ? 12 : 5;
    }

    bool hasQuadFeature()
    {
        return true;
    }

    bool hasSensFeature()
    {
        return true;
    }

    bool computeSens()
    {
        return m_pDblSensPar != NULL;
    }
    int getNbSensPar()
    {
        return (int) (m_pDblSensPar == NULL ? 0 : (m_iVecSensParIndex.size()==0 ? m_pDblSensPar->getSize() : m_iVecSensParIndex.size()));
    }

    bool hasBandPrec()
    {
        return true;
    }
private :

    CVODEManager* m_prevManager = NULL;

    functionKind m_defaultFunctionKind = RHS;

    N_Vector *m_NVArrayYS = NULL;

    std::vector<std::vector<double>> m_vecYQOut;
    std::vector<std::vector<double>> m_vecYSOut;
    std::vector<std::vector<double>> m_vecYSEvent;

    long int m_incStat[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
};

#endif
