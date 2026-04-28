//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2021-2022 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

#ifndef _LSODARMANAGER_HXX_
#define _LSODARMANAGER_HXX_

#include "dynlib_differential_equations.h"

#include "OdeManager.hxx"

#include "lsodar.h" // from modules/scicos/src/c

class DIFFERENTIAL_EQUATIONS_IMPEXP LSODARManager final : public OdeManager
{
public :

    CVODEManager(const std::wstring& callerName, const std::wstring& solverName, LSODARManager* prevManager = NULL) : OdeManager(callerName, solverName)
    {
        m_prevManager = prevManager;
        m_odeIsExtension = (prevManager != NULL);

        void * LSodarCreate (int * neq, int ng);

        // Allocating the problem
        int LSodarInit (void * lsodar_mem, LSRhsFn f, realtype t0, N_Vector y);

        // Reinitializing the problem
        int LSodarReInit (void * lsodar_mem, realtype tOld, N_Vector y);

        // Specifying the tolerances
        int LSodarSStolerances (void * lsodar_mem, realtype reltol, realtype abstol);

        // Initializing the root-finding problem
        int LSodarRootInit (void * lsodar_mem, int ng, LSRootFn g);

        // Specifying the maximum step size
        int LSodarSetMaxStep (void * lsodar_mem, realtype hmax);

        // Specifying the time beyond which the integration is not to proceed
        int LSodarSetStopTime (void * lsodar_mem, realtype tcrit);

        // Solving the problem
        int LSodar (void * lsodar_mem, realtype tOut, N_Vector yVec, realtype * tOld, int itask);

        // Update rootsfound to the computed jroots
        int LSodarGetRootInfo (void * lsodar_mem, int * rootsfound);

        // Freeing the problem memory allocated by lsodarMalloc
        void LSodarFree (void ** lsodar_mem);

        // Freeing the lsodar vectors allocated in lsodarAllocVectors
        void LSFreeVectors (LSodarMem lsodar_mem);

        // Specifies the error handler function
        int LSodarSetErrHandlerFn (void * lsodar_mem, LSErrHandlerFn ehfun, void * eh_data);

        // Error handling function
        void LSProcessError (LSodarMem ls_mem, int error_code, const char *module, const char *fname, const char *msgfmt, ...);

        // setUserData = CVodeSetUserData;
        // setInitStep = CVodeSetInitStep;
        // setMinStep = CVodeSetMinStep;
        setMaxStep = LSodarSetMaxStep;
        // setMaxNumSteps = CVodeSetMaxNumSteps;
        setStopTime = LSodarSetStopTime;
        // setMaxOrd = CVodeSetMaxOrd;
        // getCurrentTime = CVodeGetCurrentTime;
        // getCurrentStep = CVodeGetCurrentStep;
        // getLastStep = CVodeGetLastStep;
        getRootInfo = LSodarGetRootInfo;
        // setConstraints = CVodeSetConstraints;
        // setVTolerances = CVodeSVtolerances;
        setErrHandlerFn = LSodarSetErrHandlerFn;
        // getReturnFlagName = CVodeGetReturnFlagName;
        // getDky = CVodeGetDky;
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
        if (m_NVArraySens != NULL)
        {
            for (int i=0; i<getNbSensPar(); i++)
            {
                N_VDestroy(m_NVArraySens[i]);
            }
            //N_VDestroyVectorArray_Serial(m_NVArraySens, getNbSensPar());
            m_NVArraySens = NULL;
        }
        SUNDIALSMANAGER_KILLME(m_pDblSensPar);
        SUNDIALSMANAGER_KILLME(m_pDblSens0);
    };

    OdeManager *getPreviousManager()
    {
        return m_prevManager;
    }

    virtual bool isODE()
    {
        return true;
    }

    types::Double *getSOut()
    {
        // sensitivity at user prescribed timesteps or at each internal step of the method
        return getArrayFromVectors(m_pDblSens0, m_vecSOut, m_dblVecTOut.size());
    }

    types::Double *getSEvent()
    {
        return getArrayFromVectors(m_pDblSens0, m_dblVecSEvent, m_dblVecEventTime.size());
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

    bool computeSens()
    {
        return m_pDblSensPar != NULL;
    }
    int getNbSensPar()
    {
        return m_pDblSensPar == NULL ? 0 : (m_iVecSensParIndex.size()==0 ? m_pDblSensPar->getSize() : m_iVecSensParIndex.size());
    }

    bool hasBandPrec()
    {
        return true;
    }
private :

    CVODEManager* m_prevManager;

    types::Double *m_pDblSensPar = NULL;
    types::Double *m_pDblSens0 = NULL;

    N_Vector *m_NVArraySens = NULL;

    std::vector<std::vector<double>> m_vecSOut;
    std::vector<std::vector<double>> m_dblVecSEvent;

    long int m_incStat[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
};

#endif
