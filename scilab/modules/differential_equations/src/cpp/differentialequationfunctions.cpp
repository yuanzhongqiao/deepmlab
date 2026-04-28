/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2011 - DIGITEO - Cedric DELAMARRE
 *  Copyright (C) 2023 - Dassault Systèmes S.E. - Clément DAVID
 *
 * Copyright (C) 2012 - 2016 - Scilab Enterprises
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */
/*--------------------------------------------------------------------------*/
#include <vector>

#include "string.hxx"
#include "double.hxx"
#include "differentialequationfunctions.hxx"
#include "configvariable.hxx"
#include "commentexp.hxx"

extern "C"
{
#include "elem_common.h"
#include "scifunctions.h"
#include "Ex-odedc.h"
#include "Ex-ode.h"
#include "Ex-daskr.h"
#include "localization.h"
}

/*
** differential equation functions
** \{
*/

// need the current thread, not the last running thread.

std::vector<DifferentialEquationFunctions*> DifferentialEquation::m_DifferentialEquationFunctions;

using namespace types;
void DifferentialEquation::addDifferentialEquationFunctions(DifferentialEquationFunctions* _deFunction)
{
    m_DifferentialEquationFunctions.push_back(_deFunction);
}

void DifferentialEquation::removeDifferentialEquationFunctions()
{
    m_DifferentialEquationFunctions.pop_back();
}

DifferentialEquationFunctions* DifferentialEquation::getDifferentialEquationFunctions()
{
    return m_DifferentialEquationFunctions.back();
}


/*
** \}
*/
/*--------------------------------------------------------------------------*/
DifferentialEquationFunctions::DifferentialEquationFunctions(const std::wstring& callerName)
{
    m_odeYRows      = 0;
    m_odeYCols      = 0;
    m_odedcYDSize   = 0;
    m_odedcFlag     = 0;
    m_bvodeM        = 0;
    m_bvodeN        = 0;
    m_mu            = 0;
    m_ml            = 0;
    m_bandedJac     = false;

    m_wstrCaller = callerName;

    // callable
    m_pCallFFunction      = NULL;
    m_pCallJacFunction    = NULL;
    m_pCallGFunction      = NULL;
    m_pCallPjacFunction   = NULL;
    m_pCallPsolFunction   = NULL;

    // function extern
    m_pStringFFunctionDyn       = NULL;
    m_pStringJacFunctionDyn     = NULL;
    m_pStringGFunctionDyn       = NULL;
    m_pStringPjacFunctionDyn    = NULL;
    m_pStringPsolFunctionDyn    = NULL;

    // function static
    m_pStringFFunctionStatic    = NULL;
    m_pStringJacFunctionStatic  = NULL;
    m_pStringGFunctionStatic    = NULL;
    m_pStringPjacFunctionStatic = NULL;
    m_pStringPsolFunctionStatic = NULL;

    // bvode
    m_pCallFsubFunction     = NULL;
    m_pCallDfsubFunction    = NULL;
    m_pCallGsubFunction     = NULL;
    m_pCallDgsubFunction    = NULL;
    m_pCallGuessFunction    = NULL;

    m_pStringFsubFunctionDyn    = NULL;
    m_pStringDfsubFunctionDyn   = NULL;
    m_pStringGsubFunctionDyn    = NULL;
    m_pStringDgsubFunctionDyn   = NULL;
    m_pStringGuessFunctionDyn   = NULL;

    m_pStringFsubFunctionStatic     = NULL;
    m_pStringDfsubFunctionStatic    = NULL;
    m_pStringGsubFunctionStatic     = NULL;
    m_pStringDgsubFunctionStatic    = NULL;
    m_pStringGuessFunctionStatic    = NULL;

    // init static functions
    if (callerName == L"ode")
    {
        m_staticFunctionMap[L"arnol"]   = (void*) C2F(arnol);
        m_staticFunctionMap[L"fex"]     = (void*) fex;
        m_staticFunctionMap[L"fex2"]    = (void*) fex2;
        m_staticFunctionMap[L"fex3"]    = (void*) fex3;
        m_staticFunctionMap[L"fexab"]   = (void*) fexab;
        m_staticFunctionMap[L"loren"]   = (void*) C2F(loren);
        m_staticFunctionMap[L"bcomp"]   = (void*) C2F(bcomp);
        m_staticFunctionMap[L"lcomp"]   = (void*) C2F(lcomp);

        m_staticFunctionMap[L"jex"]     = (void*) jex;
    }
    else if (callerName == L"odedc")
    {
        m_staticFunctionMap[L"fcd"]     = (void*) fcd;
        m_staticFunctionMap[L"fcd1"]    = (void*) fcd1;
        m_staticFunctionMap[L"fexcd"]   = (void*) fexcd;
        m_staticFunctionMap[L"phis"]    = (void*) phis;
        m_staticFunctionMap[L"phit"]    = (void*) phit;

        m_staticFunctionMap[L"jex"]     = (void*) jex;
    }
    else if (callerName == L"intg")
    {
        m_staticFunctionMap[L"intgex"]  = (void*) C2F(intgex);
    }
    else if (callerName == L"int2d")
    {
        m_staticFunctionMap[L"int2dex"] = (void*) C2F(int2dex);
    }
    else if (callerName == L"int3d")
    {
        m_staticFunctionMap[L"int3dex"] = (void*) C2F(int3dex);
    }
    else if (callerName == L"feval")
    {
        m_staticFunctionMap[L"parab"]   = (void*) C2F(parab);
        m_staticFunctionMap[L"parabc"]  = (void*) C2F(parabc);
    }
    else if (callerName == L"bvode")
    {
        m_staticFunctionMap[L"cndg"]    = (void*) C2F(cndg);
        m_staticFunctionMap[L"cng"]     = (void*) C2F(cng);
        m_staticFunctionMap[L"cnf"]     = (void*) C2F(cnf);
        m_staticFunctionMap[L"cndf"]    = (void*) C2F(cndf);
        m_staticFunctionMap[L"cngu"]    = (void*) C2F(cngu);
    }
    else if (callerName == L"%_impl")
    {
        m_staticFunctionMap[L"resid"]   = (void*) C2F(resid);  // res
        m_staticFunctionMap[L"aplusp"]  = (void*) C2F(aplusp); // adda
        m_staticFunctionMap[L"dgbydy"]  = (void*) C2F(dgbydy); // jac
    }
    else if (callerName == L"%_dassl" ||
             callerName == L"%_dasrt" ||
             callerName == L"%_daskr")
    {
        //res
        m_staticFunctionMap[L"res1"]    = (void*) C2F(res1);
        m_staticFunctionMap[L"res2"]    = (void*) C2F(res2);
        m_staticFunctionMap[L"dres1"]   = (void*) C2F(dres1);
        m_staticFunctionMap[L"dres2"]   = (void*) C2F(dres2);

        // jac
        m_staticFunctionMap[L"jac2"]   = (void*) C2F(jac2);
        m_staticFunctionMap[L"djac2"]  = (void*) C2F(djac2);
        m_staticFunctionMap[L"djac1"]  = (void*) C2F(djac1);

        // g(t,y)
        if (callerName == L"%_dasrt")
        {
            m_staticFunctionMap[L"gr1"]  = (void*) C2F(gr1);
            m_staticFunctionMap[L"gr2"]  = (void*) C2F(gr2);
        }

        // pjac, psol, g(t,y,yd)
        if (callerName == L"%_daskr")
        {
            m_staticFunctionMap[L"grd1"]  = (void*) C2F(grd1);
            m_staticFunctionMap[L"grd2"]  = (void*) C2F(grd2);
            m_staticFunctionMap[L"pjac1"]  = (void*) pjac1;
            m_staticFunctionMap[L"psol1"]  = (void*) psol1;
        }
    }
}

DifferentialEquationFunctions::~DifferentialEquationFunctions()
{
    m_staticFunctionMap.clear();
}

/*------------------------------- public -------------------------------------------*/
void DifferentialEquationFunctions::execDasrtG(int* ny, double* t, double* y, int* ng, double* gout, double* rpar, int* ipar)
{
    char errorMsg[256];
    if (m_pCallGFunction)
    {
        callDasrtMacroG(ny, t, y, ng, gout, rpar, ipar);
    }
    else if (m_pStringGFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringGFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringGFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }
        ((dasrt_g_t)(func->functionPtr))(ny, t, y, ng, gout, rpar, ipar);
    }
    else if (m_pStringGFunctionStatic)
    {
        ((dasrt_g_t)m_staticFunctionMap[m_pStringGFunctionStatic->get(0)])(ny, t, y, ng, gout, rpar, ipar);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "g");
        throw ast::InternalError(errorMsg);
    }
}

void DifferentialEquationFunctions::execDasslF(double* t, double* y, double* ydot, double* delta, int* ires, double* rpar, int* ipar)
{
    char errorMsg[256];
    if (m_pCallFFunction)
    {
        callDasslMacroF(t, y, ydot, delta, ires, rpar, ipar);
    }
    else if (m_pStringFFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringFFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringFFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }
        ((dassl_f_t)(func->functionPtr))(t, y, ydot, delta, ires, rpar, ipar);
    }
    else if (m_pStringFFunctionStatic)
    {
        ((dassl_f_t)m_staticFunctionMap[m_pStringFFunctionStatic->get(0)])(t, y, ydot, delta, ires, rpar, ipar);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "f");
        throw ast::InternalError(errorMsg);
    }
}

void DifferentialEquationFunctions::execDasslJac(double* t, double* y, double* ydot, double* pd, double* cj, double* rpar, int* ipar)
{
    char errorMsg[256];
    if (m_pCallJacFunction)
    {
        callDasslMacroJac(t, y, ydot, pd, cj, rpar, ipar);
    }
    else if (m_pStringJacFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringJacFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringJacFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }
        ((dassl_jac_t)(func->functionPtr))(t, y, ydot, pd, cj, rpar, ipar);
    }
    else if (m_pStringJacFunctionStatic)
    {
        ((dassl_jac_t)m_staticFunctionMap[m_pStringJacFunctionStatic->get(0)])(t, y, ydot, pd, cj, rpar, ipar);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "jacobian");
        throw ast::InternalError(errorMsg);
    }
}

void DifferentialEquationFunctions::execDaskrG(int* ny, double* t, double* y, double* ydot, int* ng, double* gout, double* rpar, int* ipar)
{
    char errorMsg[256];
    if (m_pCallGFunction)
    {
        callDaskrMacroG(ny, t, y, ydot, ng, gout, rpar, ipar);
    }
    else if (m_pStringGFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringGFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringGFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }
        ((dasrkr_g_t)(func->functionPtr))(ny, t, y, ydot, ng, gout, rpar, ipar);
    }
    else if (m_pStringGFunctionStatic)
    {
        ((dasrkr_g_t)m_staticFunctionMap[m_pStringGFunctionStatic->get(0)])(ny, t, y, ydot, ng, gout, rpar, ipar);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "g");
        throw ast::InternalError(errorMsg);
    }
}

void DifferentialEquationFunctions::execDaskrPjac(double* res, int* ires, int* neq, double* t, double* y, double* ydot,
        double* rewt, double* savr, double* wk, double* h, double* cj,
        double* wp, int* iwp, int* ier, double* rpar, int* ipar)
{
    char errorMsg[256];
    if (m_pCallPjacFunction)
    {
        callDaskrMacroPjac(res, ires, neq, t, y, ydot, rewt, savr,
                           wk, h, cj, wp, iwp, ier, rpar, ipar);
    }
    else if (m_pStringPjacFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringPjacFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringPjacFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }
        ((daskr_pjac_t)(func->functionPtr))(res, ires, neq, t, y, ydot, rewt, savr,
                                            wk, h, cj, wp, iwp, ier, rpar, ipar);
    }
    else if (m_pStringPjacFunctionStatic)
    {
        ((daskr_pjac_t)m_staticFunctionMap[m_pStringPjacFunctionStatic->get(0)])(res, ires, neq, t, y, ydot, rewt, savr,
                wk, h, cj, wp, iwp, ier, rpar, ipar);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "pjac");
        throw ast::InternalError(errorMsg);
    }
}

void DifferentialEquationFunctions::execDaskrPsol(int* neq, double* t, double* y, double* ydot, double* savr, double* wk,
        double* cj, double* wght, double* wp, int* iwp, double* b, double* eplin,
        int* ier, double* rpar, int* ipar)
{
    char errorMsg[256];
    if (m_pCallPsolFunction)
    {
        callDaskrMacroPsol(neq, t, y, ydot, savr, wk, cj, wght,
                           wp, iwp, b, eplin, ier, rpar, ipar);
    }
    else if (m_pStringPsolFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringPsolFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringPsolFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }
        ((daskr_psol_t)(func->functionPtr))(neq, t, y, ydot, savr, wk, cj, wght,
                                            wp, iwp, b, eplin, ier, rpar, ipar);
    }
    else if (m_pStringPsolFunctionStatic)
    {
        ((daskr_psol_t)m_staticFunctionMap[m_pStringPsolFunctionStatic->get(0)])(neq, t, y, ydot, savr, wk, cj, wght,
                wp, iwp, b, eplin, ier, rpar, ipar);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "psol");
        throw ast::InternalError(errorMsg);
    }
}

void DifferentialEquationFunctions::execImplF(int* neq, double* t, double* y, double* s, double* r, int* ires)
{
    char errorMsg[256];
    if (m_pCallFFunction)
    {
        callImplMacroF(neq, t, y, s, r, ires);
    }
    else if (m_pStringFFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringFFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringFFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }
        ((impl_f_t)(func->functionPtr))(neq, t, y, s, r, ires);
    }
    else if (m_pStringFFunctionStatic)
    {
        ((impl_f_t)m_staticFunctionMap[m_pStringFFunctionStatic->get(0)])(neq, t, y, s, r, ires);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "f");
        throw ast::InternalError(errorMsg);
    }
}

void DifferentialEquationFunctions::execImplG(int* neq, double* t, double* y, double* ml, double* mu, double* p, int* nrowp)
{
    char errorMsg[256];
    if (m_pCallGFunction)
    {
        callImplMacroG(neq, t, y, ml, mu, p, nrowp);
    }
    else if (m_pStringGFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringGFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringGFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }
        ((impl_g_t)(func->functionPtr))(neq, t, y, ml, mu, p, nrowp);
    }
    else if (m_pStringGFunctionStatic)
    {
        ((impl_g_t)m_staticFunctionMap[m_pStringGFunctionStatic->get(0)])(neq, t, y, ml, mu, p, nrowp);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "g");
        throw ast::InternalError(errorMsg);
    }
}

void DifferentialEquationFunctions::execImplJac(int* neq, double* t, double* y, double* s, double* ml, double* mu, double* p, int* nrowp)
{
    char errorMsg[256];
    if (m_pCallJacFunction)
    {
        callImplMacroJac(neq, t, y, s, ml, mu, p, nrowp);
    }
    else if (m_pStringJacFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringJacFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringJacFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }
        ((impl_jac_t)(func->functionPtr))(neq, t, y, s, ml, mu, p, nrowp);
    }
    else if (m_pStringJacFunctionStatic)
    {
        ((impl_jac_t)m_staticFunctionMap[m_pStringJacFunctionStatic->get(0)])(neq, t, y, s, ml, mu, p, nrowp);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "jacobian");
        throw ast::InternalError(errorMsg);
    }
}

void DifferentialEquationFunctions::execBvodeGuess(double *x, double *z, double *d)
{
    char errorMsg[256];
    if (m_pCallGuessFunction)
    {
        callBvodeMacroGuess(x, z, d);
    }
    else if (m_pStringGuessFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringGuessFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringGuessFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }
        ((bvode_ddd_t)(func->functionPtr))(x, z, d);
    }
    else if (m_pStringGuessFunctionStatic)
    {
        ((bvode_ddd_t)m_staticFunctionMap[m_pStringGuessFunctionStatic->get(0)])(x, z, d);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "guess");
        throw ast::InternalError(errorMsg);
    }
}

void DifferentialEquationFunctions::execBvodeDfsub(double *x, double *z, double *d)
{
    char errorMsg[256];
    if (m_pCallDfsubFunction)
    {
        callBvodeMacroDfsub(x, z, d);
    }
    else if (m_pStringDfsubFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringDfsubFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringDfsubFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }
        ((bvode_ddd_t)(func->functionPtr))(x, z, d);
    }
    else if (m_pStringDfsubFunctionStatic)// function static
    {
        ((bvode_ddd_t)m_staticFunctionMap[m_pStringDfsubFunctionStatic->get(0)])(x, z, d);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "fsub");
        throw ast::InternalError(errorMsg);
    }
}

void DifferentialEquationFunctions::execBvodeFsub(double *x, double *z, double *d)
{
    char errorMsg[256];
    if (m_pCallFsubFunction)
    {
        callBvodeMacroFsub(x, z, d);
    }
    else if (m_pStringFsubFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringFsubFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringFsubFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }
        ((bvode_ddd_t)(func->functionPtr))(x, z, d);
    }
    else if (m_pStringFsubFunctionStatic) // function static
    {
        ((bvode_ddd_t)m_staticFunctionMap[m_pStringFsubFunctionStatic->get(0)])(x, z, d);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "fsub");
        throw ast::InternalError(errorMsg);
    }
}

void DifferentialEquationFunctions::execBvodeDgsub(int *i, double *z, double *g)
{
    char errorMsg[256];
    if (m_pCallDgsubFunction)
    {
        callBvodeMacroDgsub(i, z, g);
    }
    else if (m_pStringDgsubFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringDgsubFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringDgsubFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }
        ((bvode_idd_t)(func->functionPtr))(i, z, g);
    }
    else if (m_pStringDgsubFunctionStatic) // function static
    {
        ((bvode_idd_t)m_staticFunctionMap[m_pStringDgsubFunctionStatic->get(0)])(i, z, g);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "gsub");
        throw ast::InternalError(errorMsg);
    }
}

void DifferentialEquationFunctions::execBvodeGsub(int *i, double *z, double *g)
{
    char errorMsg[256];
    if (m_pCallGsubFunction)
    {
        callBvodeMacroGsub(i, z, g);
    }
    else if (m_pStringGsubFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringGsubFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringGsubFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }
        ((bvode_idd_t)(func->functionPtr))(i, z, g);
    }
    else if (m_pStringGsubFunctionStatic) // function static
    {
        ((bvode_idd_t)m_staticFunctionMap[m_pStringGsubFunctionStatic->get(0)])(i, z, g);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "gsub");
        throw ast::InternalError(errorMsg);
    }
}

void DifferentialEquationFunctions::execFevalF(int *nn, double *x1, double *x2, double *xres, int *itype)
{
    char errorMsg[256];
    if (m_pCallFFunction)
    {
        callFevalMacroF(nn, x1, x2, xres, itype);
    }
    else if (m_pStringFFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringFFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringFFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }

        ((feval_f_t)(func->functionPtr))(nn, x1, x2, xres, itype);
    }
    else if (m_pStringFFunctionStatic) // function static
    {
        ((feval_f_t)m_staticFunctionMap[m_pStringFFunctionStatic->get(0)])(nn, x1, x2, xres, itype);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "f");
        throw ast::InternalError(errorMsg);
    }
}

void DifferentialEquationFunctions::execInt3dF(double* x, int* numfun, double* funvls)
{
    char errorMsg[256];
    if (m_pCallFFunction)
    {
        callInt3dMacroF(x, numfun, funvls);
    }
    else if (m_pStringFFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringFFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringFFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }
        ((int3d_f_t)(func->functionPtr))(x, numfun, funvls);
    }
    else if (m_pStringFFunctionStatic) // function static
    {
        ((int3d_f_t)m_staticFunctionMap[m_pStringFFunctionStatic->get(0)])(x, numfun, funvls);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "f");
        throw ast::InternalError(errorMsg);
    }
}

double DifferentialEquationFunctions::execInt2dF(double* x, double* y)
{
    char errorMsg[256];
    if (m_pCallFFunction)
    {
        return callInt2dMacroF(x, y);
    }
    else if (m_pStringFFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringFFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringFFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }
        return ((int2d_f_t)(func->functionPtr))(x, y);
    }
    else if (m_pStringFFunctionStatic) // function static
    {
        return ((int2d_f_t)m_staticFunctionMap[m_pStringFFunctionStatic->get(0)])(x, y);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "f");
        throw ast::InternalError(errorMsg);
    }
}

double DifferentialEquationFunctions::execIntgF(double* x)
{
    char errorMsg[256];
    if (m_pCallFFunction)
    {
        return callIntgMacroF(x);
    }
    else if (m_pStringFFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringFFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringFFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }
        return ((intg_f_t)(func->functionPtr))(x);
    }
    else if (m_pStringFFunctionStatic) // function static
    {
        return ((intg_f_t)m_staticFunctionMap[m_pStringFFunctionStatic->get(0)])(x);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "f");
        throw ast::InternalError(errorMsg);
    }
}

void DifferentialEquationFunctions::execOdeF(int* n, double* t, double* y, double* yout)
{
    char errorMsg[256];
    if (m_pCallFFunction)
    {
        callOdeMacroF(n, t, y, yout);
    }
    else if (m_pStringFFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringFFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringFFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }

        if (m_wstrCaller == L"ode")
        {
            ((ode_f_t)(func->functionPtr))(n, t, y, yout);
        }
        else
        {
            ((odedc_f_t)(func->functionPtr))(&m_odedcFlag, n, &m_odedcYDSize, t, y, yout);
        }
    }
    else if (m_pStringFFunctionStatic) // function static
    {
        if (m_wstrCaller == L"ode")
        {
            ((ode_f_t)m_staticFunctionMap[m_pStringFFunctionStatic->get(0)])(n, t, y, yout);
        }
        else // if (m_wstrCaller == L"odedc")
        {
            ((odedc_f_t)m_staticFunctionMap[m_pStringFFunctionStatic->get(0)])(&m_odedcFlag, n, &m_odedcYDSize, t, y, yout);
        }
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "f");
        throw ast::InternalError(errorMsg);
    }
}

void DifferentialEquationFunctions::execFunctionJac(int *n, double *t, double *y, int *ml, int *mu, double *J, int *nrpd)
{
    char errorMsg[256];
    if (m_pCallJacFunction)
    {
        callMacroJac(n, t, y, ml, mu, J, nrpd);
    }
    else if (m_pStringJacFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringJacFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringJacFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }
        ((func_jac_t)(func->functionPtr))(n, t, y, ml, mu, J, nrpd);
    }
    else if (m_pStringJacFunctionStatic) // function static
    {
        ((func_jac_t)m_staticFunctionMap[m_pStringJacFunctionStatic->get(0)])(n, t, y, ml, mu, J, nrpd);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "jacobian");
        throw ast::InternalError(errorMsg);
    }
}

void DifferentialEquationFunctions::execFunctionG(int* n, double* t, double* y, int* ng, double* gout)
{
    char errorMsg[256];
    if (m_pCallGFunction)
    {
        callMacroG(n, t, y, ng, gout);
    }
    else if (m_pStringGFunctionDyn)
    {
        ConfigVariable::EntryPointStr* func = ConfigVariable::getEntryPoint(m_pStringGFunctionDyn->get(0));
        if (func == NULL)
        {
            sprintf(errorMsg, _("Undefined function '%ls'.\n"), m_pStringGFunctionDyn->get(0));
            throw ast::InternalError(errorMsg);
        }
        ((func_g_t)(func->functionPtr))(n, t, y, ng, gout);
    }
    else if (m_pStringGFunctionStatic)// function static
    {
        ((func_g_t)m_staticFunctionMap[m_pStringGFunctionStatic->get(0)])(n, t, y, ng, gout);
    }
    else
    {
        sprintf(errorMsg, _("User function '%s' have not been set.\n"), "g");
        throw ast::InternalError(errorMsg);
    }
}

//*** setter ***
// set rows cols
void DifferentialEquationFunctions::setOdeYRows(int rows)
{
    m_odeYRows = rows;
}

void DifferentialEquationFunctions::setOdeYCols(int cols)
{
    m_odeYCols = cols;
}

// set odedc yd size
void DifferentialEquationFunctions::setOdedcYDSize(int size)
{
    m_odedcYDSize = size;
}

// set odedc flag
void DifferentialEquationFunctions::setOdedcFlag()
{
    m_odedcFlag = 1;
}

// reset odedc flag
void DifferentialEquationFunctions::resetOdedcFlag()
{
    m_odedcFlag = 0;
}

void DifferentialEquationFunctions::setBvodeM(int _m)
{
    m_bvodeM = _m;
}

void DifferentialEquationFunctions::setBvodeN(int _n)
{
    m_bvodeN = _n;
}

//set function f, jac, g, psol, pjac as types::Callable
void DifferentialEquationFunctions::setFFunction(types::Callable* _odeFFunc)
{
    m_pCallFFunction = _odeFFunc;
}

void DifferentialEquationFunctions::setJacFunction(types::Callable* _odeJacFunc)
{
    m_pCallJacFunction = _odeJacFunc;
}

void DifferentialEquationFunctions::setGFunction(types::Callable* _odeGFunc)
{
    m_pCallGFunction = _odeGFunc;
}

void DifferentialEquationFunctions::setPsolFunction(types::Callable* _pSolFunc)
{
    m_pCallPsolFunction = _pSolFunc;
}

void DifferentialEquationFunctions::setPjacFunction(types::Callable* _pJacFunc)
{
    m_pCallPjacFunction = _pJacFunc;
}

//set function f, jac, g, psol, pjac as types::String
bool DifferentialEquationFunctions::setFFunction(types::String* _odeFFunc)
{
    if (ConfigVariable::getEntryPoint(_odeFFunc->get(0)))
    {
        m_pStringFFunctionDyn = _odeFFunc;
        return true;
    }
    else
    {
        if (m_staticFunctionMap.find(_odeFFunc->get(0)) != m_staticFunctionMap.end())
        {
            m_pStringFFunctionStatic = _odeFFunc;
            return true;
        }
        return false;
    }
}

bool DifferentialEquationFunctions::setJacFunction(types::String* _odeJacFunc)
{
    if (ConfigVariable::getEntryPoint(_odeJacFunc->get(0)))
    {
        m_pStringJacFunctionDyn = _odeJacFunc;
        return true;
    }
    else
    {
        if (m_staticFunctionMap.find(_odeJacFunc->get(0)) != m_staticFunctionMap.end())
        {
            m_pStringJacFunctionStatic = _odeJacFunc;
            return true;
        }
        return false;
    }
}

bool DifferentialEquationFunctions::setGFunction(types::String* _odeGFunc)
{
    if (ConfigVariable::getEntryPoint(_odeGFunc->get(0)))
    {
        m_pStringGFunctionDyn = _odeGFunc;
        return true;
    }
    else
    {
        if (m_staticFunctionMap.find(_odeGFunc->get(0)) != m_staticFunctionMap.end())
        {
            m_pStringGFunctionStatic = _odeGFunc;
            return true;
        }
        return false;
    }
}

bool DifferentialEquationFunctions::setPsolFunction(types::String* _pSolFunc)
{
    if (ConfigVariable::getEntryPoint(_pSolFunc->get(0)))
    {
        m_pStringPsolFunctionDyn = _pSolFunc;
        return true;
    }
    else
    {
        if (m_staticFunctionMap.find(_pSolFunc->get(0)) != m_staticFunctionMap.end())
        {
            m_pStringPsolFunctionStatic = _pSolFunc;
            return true;
        }
        return false;
    }
}

bool DifferentialEquationFunctions::setPjacFunction(types::String* _pJacFunc)
{
    if (ConfigVariable::getEntryPoint(_pJacFunc->get(0)))
    {
        m_pStringPjacFunctionDyn = _pJacFunc;
        return true;
    }
    else
    {
        if (m_staticFunctionMap.find(_pJacFunc->get(0)) != m_staticFunctionMap.end())
        {
            m_pStringPjacFunctionStatic = _pJacFunc;
            return true;
        }
        return false;
    }
}

// set args for f, jac, g, pjac and psol functions
void DifferentialEquationFunctions::setFArgs(types::InternalType* _odeFArg)
{
    m_FArgs.push_back(_odeFArg);
}

void DifferentialEquationFunctions::setJacArgs(types::InternalType* _odeJacArg)
{
    m_JacArgs.push_back(_odeJacArg);
}

void DifferentialEquationFunctions::setGArgs(types::InternalType* _odeGArg)
{
    m_odeGArgs.push_back(_odeGArg);
}

void DifferentialEquationFunctions::setPsolArgs(types::InternalType* _pSolArg)
{
    m_pSolArgs.push_back(_pSolArg);
}

void DifferentialEquationFunctions::setPjacArgs(types::InternalType* _pJacArg)
{
    m_pJacArgs.push_back(_pJacArg);
}

// bvode set function as types::Callable gsub, dgsub, fsub, dfsub, guess
void DifferentialEquationFunctions::setGsubFunction(types::Callable* _func)
{
    m_pCallGsubFunction = _func;
}

void DifferentialEquationFunctions::setDgsubFunction(types::Callable* _func)
{
    m_pCallDgsubFunction = _func;
}

void DifferentialEquationFunctions::setFsubFunction(types::Callable* _func)
{
    m_pCallFsubFunction = _func;
}

void DifferentialEquationFunctions::setDfsubFunction(types::Callable* _func)
{
    m_pCallDfsubFunction = _func;
}

void DifferentialEquationFunctions::setGuessFunction(types::Callable* _func)
{
    m_pCallGuessFunction = _func;
}

// bvode set function as types::String gsub, dgsub, fsub, dfsub, guess
bool DifferentialEquationFunctions::setGsubFunction(types::String* _func)
{
    if (ConfigVariable::getEntryPoint(_func->get(0)))
    {
        m_pStringGsubFunctionDyn = _func;
        return true;
    }
    else
    {
        if (m_staticFunctionMap.find(_func->get(0)) != m_staticFunctionMap.end())
        {
            m_pStringGsubFunctionStatic = _func;
            return true;
        }
        return false;
    }
}

bool DifferentialEquationFunctions::setDgsubFunction(types::String* _func)
{
    if (ConfigVariable::getEntryPoint(_func->get(0)))
    {
        m_pStringDgsubFunctionDyn = _func;
        return true;
    }
    else
    {
        if (m_staticFunctionMap.find(_func->get(0)) != m_staticFunctionMap.end())
        {
            m_pStringDgsubFunctionStatic = _func;
            return true;
        }
        return false;
    }
}

bool DifferentialEquationFunctions::setFsubFunction(types::String* _func)
{
    if (ConfigVariable::getEntryPoint(_func->get(0)))
    {
        m_pStringFsubFunctionDyn = _func;
        return true;
    }
    else
    {
        if (m_staticFunctionMap.find(_func->get(0)) != m_staticFunctionMap.end())
        {
            m_pStringFsubFunctionStatic = _func;
            return true;
        }
        return false;
    }
}

bool DifferentialEquationFunctions::setDfsubFunction(types::String* _func)
{
    if (ConfigVariable::getEntryPoint(_func->get(0)))
    {
        m_pStringDfsubFunctionDyn = _func;
        return true;
    }
    else
    {
        if (m_staticFunctionMap.find(_func->get(0)) != m_staticFunctionMap.end())
        {
            m_pStringDfsubFunctionStatic = _func;
            return true;
        }
        return false;
    }
}

bool DifferentialEquationFunctions::setGuessFunction(types::String* _func)
{
    if (ConfigVariable::getEntryPoint(_func->get(0)))
    {
        m_pStringGuessFunctionDyn = _func;
        return true;
    }
    else
    {
        if (m_staticFunctionMap.find(_func->get(0)) != m_staticFunctionMap.end())
        {
            m_pStringGuessFunctionStatic = _func;
            return true;
        }
        return false;
    }
}

// bvode set set args for gsub, dgsub, fsub, dfsub, guess functions
void DifferentialEquationFunctions::setGsubArgs(types::InternalType* _arg)
{
    m_GsubArgs.push_back(_arg);
}

void DifferentialEquationFunctions::setDgsubArgs(types::InternalType* _arg)
{
    m_DgsubArgs.push_back(_arg);
}

void DifferentialEquationFunctions::setFsubArgs(types::InternalType* _arg)
{
    m_FsubArgs.push_back(_arg);
}

void DifferentialEquationFunctions::setDfsubArgs(types::InternalType* _arg)
{
    m_DfsubArgs.push_back(_arg);
}

void DifferentialEquationFunctions::setGuessArgs(types::InternalType* _arg)
{
    m_GuessArgs.push_back(_arg);
}

// set mu and ml
void DifferentialEquationFunctions::setMu(int mu)
{
    m_bandedJac = true;
    m_mu = mu;
}

void DifferentialEquationFunctions::setMl(int ml)
{
    m_bandedJac = true;
    m_ml = ml;
}

//*** getter ***
// get y rows cols
int DifferentialEquationFunctions::getOdeYRows()
{
    return m_odeYRows;
}

int DifferentialEquationFunctions::getOdeYCols()
{
    return m_odeYCols;
}

// get odedc yd size
int DifferentialEquationFunctions::getOdedcYDSize()
{
    return m_odedcYDSize;
}

// get odedc flag
int DifferentialEquationFunctions::getOdedcFlag()
{
    return m_odedcFlag;
}
/*------------------------------- private -------------------------------------------*/
namespace {
// helper struct for calling macros
struct args_t {
    types::typed_list in;
    types::typed_list out;
    types::optional_list opt;

    ~args_t()
    {
        for (types::InternalType* o : out)
        {
            o->IncreaseRef();
        }

        for (types::InternalType* i : in)
        {
            i->DecreaseRef();
            i->killMe();
        }
        
        for (const auto& o : opt)
        {
            o.second->DecreaseRef();
            o.second->killMe();
        }

        for (types::InternalType* o : out)
        {
            o->DecreaseRef();
            o->killMe();
        }
    };

    void add_in(types::InternalType* arg)
    {
        arg->IncreaseRef();
        in.push_back(arg);
    };

    void add_opt(const std::wstring& name, types::InternalType* arg)
    {
        arg->IncreaseRef();
        opt.insert({name, arg});
    };
};
} /* namespace */

void DifferentialEquationFunctions::callOdeMacroF(int* n, double* t, double* y, double* ydot)
{
    char errorMsg[256];
    int one         = 1;
    int iRetCount   = 1;

    args_t args;

    types::Double* pDblY    = NULL;
    types::Double* pDblYC   = NULL;
    types::Double* pDblYD   = NULL;
    types::Double* pDblFlag = NULL;

    // create input args
    types::Double* pDblT = new types::Double(*t);
    args.add_in(pDblT);

    if (m_odedcYDSize) // odedc
    {
        pDblYC = new types::Double(*n, 1);
        pDblYC->set(y);
        args.add_in(pDblYC);
        pDblYD = new types::Double(m_odedcYDSize, 1);
        pDblYD->set(y + *n);
        args.add_in(pDblYD);
        pDblFlag = new types::Double(m_odedcFlag);
        args.add_in(pDblFlag);
    }
    else // ode
    {
        pDblY = new types::Double(m_odeYRows, m_odeYCols);
        pDblY->set(y);
        args.add_in(pDblY);
    }

    for (int i = 0; i < (int)m_FArgs.size(); i++)
    {
        args.add_in(m_FArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallFFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }
    types::Double* pDblOut = args.out[0]->getAs<types::Double>();
    if (pDblOut->isComplex())
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (m_odedcFlag && m_odedcYDSize)
    {
        C2F(dcopy)(&m_odedcYDSize, pDblOut->get(), &one, ydot, &one);
    }
    else
    {
        C2F(dcopy)(n, pDblOut->get(), &one, ydot, &one);
    }
}

void DifferentialEquationFunctions::callMacroJac(int* n, double* t, double* y, int* ml, int* mu, double* J, int* nrpd)
{
    char errorMsg[256];
    int iRetCount   = 1;
    int one         = 1;
    int iMaxSize    = (*n) * (*nrpd);

    args_t args;

    types::Double* pDblY = new types::Double(m_odeYRows, m_odeYCols);
    pDblY->set(y);
    types::Double* pDblT = new types::Double(*t);

    args.add_in(pDblT);
    args.add_in(pDblY);

    for (int i = 0; i < (int)m_JacArgs.size(); i++)
    {
        args.add_in(m_JacArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallJacFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {   
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallJacFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallJacFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }


    types::Double* pDblOut = args.out[0]->getAs<types::Double>();
    int iSizeOut = pDblOut->getSize();

    if (iSizeOut > iMaxSize)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallJacFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A size less or equal than %d expected.\n"), pstrName, 1, iMaxSize);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    C2F(dcopy)(&iSizeOut, pDblOut->get(), &one, J, &one);
}

void DifferentialEquationFunctions::callMacroG(int* n, double* t, double* y, int* ng, double* gout)
{
    char errorMsg[256];
    int iRetCount   = 1;
    int one         = 1;

    args_t args;

    types::Double* pDblY = new types::Double(m_odeYRows, m_odeYCols);
    pDblY->set(y);
    types::Double* pDblT = new types::Double(*t);

    args.add_in(pDblT);
    args.add_in(pDblY);

    for (int i = 0; i < (int)m_odeGArgs.size(); i++)
    {
        args.add_in(m_odeGArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallGFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallGFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallGFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    C2F(dcopy)(ng, args.out[0]->getAs<types::Double>()->get(), &one, gout, &one);
}

double DifferentialEquationFunctions::callIntgMacroF(double* t)
{
    char errorMsg[256];
    int iRetCount   = 1;

    args_t args;
    
    // create input args
    types::Double* pDblT = new types::Double(*t);
    args.add_in(pDblT);

    for (int i = 0; i < (int)m_FArgs.size(); i++)
    {
        args.add_in(m_FArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallFFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);

    }

    types::Double* pDblOut = args.out[0]->getAs<types::Double>();
    if (pDblOut->getSize() != 1)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A Scalar expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    return pDblOut->get(0);
}

double DifferentialEquationFunctions::callInt2dMacroF(double* x, double* y)
{
    char errorMsg[256];
    int iRetCount   = 1;

    args_t args;
    // create input args
    types::Double* pDblX = new types::Double(*x);
    types::Double* pDblY = new types::Double(*y);
    
    args.add_in(pDblX);
    args.add_in(pDblY);

    for (int i = 0; i < (int)m_FArgs.size(); i++)
    {
        args.add_in(m_FArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallFFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    types::Double* pDblOut = args.out[0]->getAs<types::Double>();
    if (pDblOut->getSize() != 1)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A Scalar expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    return pDblOut->get(0);
}

void DifferentialEquationFunctions::callInt3dMacroF(double* xyz, int* numfun, double* funvls)
{
    char errorMsg[256];
    int one         = 1;
    int iRetCount   = 1;

    args_t args;
    
    // create input args
    types::Double* pDblXYZ = new types::Double(3, 1);
    pDblXYZ->set(xyz);
    types::Double* pDblNumfun = new types::Double(*numfun);
    
    args.add_in(pDblXYZ);
    args.add_in(pDblNumfun);

    for (int i = 0; i < (int)m_FArgs.size(); i++)
    {
        args.add_in(m_FArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallFFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    types::Double* pDblOut = args.out[0]->getAs<types::Double>();
    if (pDblOut->getSize() != *numfun)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: Matrix of size %d expected.\n"), pstrName, 1, *numfun);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    C2F(dcopy)(numfun, pDblOut->get(), &one, funvls, &one);
}

void DifferentialEquationFunctions::callFevalMacroF(int* nn, double* x1, double* x2, double* xres, int* itype)
{
    char errorMsg[256];
    int iRetCount   = 1;

    args_t args;

    types::Double* pDblX = NULL;
    types::Double* pDblY = NULL;

    // create input args

    pDblX = new types::Double(*x1);
    args.add_in(pDblX);

    if (*nn == 2)
    {
        pDblY = new types::Double(*x2);
        args.add_in(pDblY);
    }

    for (int i = 0; i < (int)m_FArgs.size(); i++)
    {
        args.add_in(m_FArgs[i]);
    }
    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallFFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);

    }

    types::Double* pDblOut = args.out[0]->getAs<types::Double>();
    if (pDblOut->getSize() != 1)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A Scalar expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (pDblOut->isComplex())
    {
        *itype = 1;
        xres[0] = pDblOut->get(0);
        xres[1] = pDblOut->getImg(0);
    }
    else
    {
        *itype = 0;
        xres[0] = pDblOut->get(0);
    }
}

void DifferentialEquationFunctions::callBvodeMacroGsub(int* i, double* z, double* g)
{
    char errorMsg[256];
    int iRetCount   = 1;

    args_t args;

    types::Double* pDblI = NULL;
    types::Double* pDblZ = NULL;

    pDblI = new types::Double(*i);
    args.add_in(pDblI);

    pDblZ = new types::Double(m_bvodeM, 1);
    pDblZ->set(z);
    args.add_in(pDblZ);

    for (int i = 0; i < (int)m_GsubArgs.size(); i++)
    {
        args.add_in(m_GsubArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallGsubFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallGsubFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallGsubFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    types::Double* pDblOut = args.out[0]->getAs<types::Double>();
    if (pDblOut->getSize() != 1)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallGsubFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A Scalar expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    *g = pDblOut->get(0);
}

void DifferentialEquationFunctions::callBvodeMacroDgsub(int* i, double* z, double* g)
{
    char errorMsg[256];
    int one         = 1;
    int iRetCount   = 1;

    args_t args;
    
    types::Double* pDblI = NULL;
    types::Double* pDblZ = NULL;

    pDblI = new types::Double(*i);
    args.add_in(pDblI);

    pDblZ = new types::Double(m_bvodeM, 1);
    pDblZ->set(z);
    args.add_in(pDblZ);

    for (int i = 0; i < (int)m_DgsubArgs.size(); i++)
    {
        args.add_in(m_DgsubArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallDgsubFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallDgsubFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallDgsubFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    types::Double* pDblOut = args.out[0]->getAs<types::Double>();
    if (pDblOut->getSize() != m_bvodeM)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallDgsubFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A Matrix of size %d expected.\n"), pstrName, 1, m_bvodeM);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    C2F(dcopy)(&m_bvodeM, pDblOut->get(), &one, g, &one);
}

void DifferentialEquationFunctions::callBvodeMacroFsub(double* x, double* z, double* d)
{
    char errorMsg[256];
    int one         = 1;
    int iRetCount   = 1;

    args_t args;

    types::Double* pDblX = NULL;
    types::Double* pDblZ = NULL;

    pDblX = new types::Double(*x);
    args.add_in(pDblX);

    pDblZ = new types::Double(m_bvodeM, 1);
    pDblZ->set(z);
    args.add_in(pDblZ);

    for (int i = 0; i < (int)m_FsubArgs.size(); i++)
    {
        args.add_in(m_FsubArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallFsubFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFsubFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFsubFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    types::Double* pDblOut = args.out[0]->getAs<types::Double>();
    if (pDblOut->getSize() != m_bvodeN)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFsubFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A matrix of size %d expected.\n"), pstrName, 1, m_bvodeN);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    C2F(dcopy)(&m_bvodeN, pDblOut->get(), &one, d, &one);
}

void DifferentialEquationFunctions::callBvodeMacroDfsub(double* x, double* z, double* d)
{
    char errorMsg[256];
    int one         = 1;
    int iRetCount   = 1;

    args_t args;

    types::Double* pDblX = NULL;
    types::Double* pDblZ = NULL;

    pDblX = new types::Double(*x);
    args.add_in(pDblX);

    pDblZ = new types::Double(m_bvodeM, 1);
    pDblZ->set(z);
    args.add_in(pDblZ);

    for (int i = 0; i < (int)m_DfsubArgs.size(); i++)
    {
        args.add_in(m_DfsubArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallDfsubFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallDfsubFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallDfsubFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    types::Double* pDblOut = args.out[0]->getAs<types::Double>();
    int size = m_bvodeN * m_bvodeM;
    if (pDblOut->getSize() != size)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallDfsubFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A matrix of size %d expected.\n"), pstrName, 1, size);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    C2F(dcopy)(&size, pDblOut->get(), &one, d, &one);
}

void DifferentialEquationFunctions::callBvodeMacroGuess(double* x, double* z, double* d)
{
    char errorMsg[256];
    int one         = 1;
    int iRetCount   = 2;

    args_t args;

    types::Double* pDblX = NULL;

    pDblX = new types::Double(*x);
    args.add_in(pDblX);

    for (int i = 0; i < (int)m_GuessArgs.size(); i++)
    {
        args.add_in(m_GuessArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallGuessFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallGuessFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallGuessFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[1]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallGuessFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 2);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    types::Double* pDblOutZ = args.out[0]->getAs<types::Double>();
    if (pDblOutZ->getSize() != m_bvodeM)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallGuessFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A matrix of size %d expected.\n"), pstrName, 1, m_bvodeM);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    types::Double* pDblOutD = args.out[1]->getAs<types::Double>();
    if (pDblOutD->getSize() != m_bvodeN)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallGuessFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A matrix of size %d expected.\n"), pstrName, 1, m_bvodeN);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    C2F(dcopy)(&m_bvodeM, pDblOutZ->get(), &one, z, &one);
    C2F(dcopy)(&m_bvodeN, pDblOutD->get(), &one, d, &one);
}

void DifferentialEquationFunctions::callImplMacroF(int* neq, double* t, double* y, double*s, double* r, int* ires)
{
    char errorMsg[256];
    int one         = 1;
    int iRetCount   = 1;

    *ires = 2;

    args_t args;
    
    types::Double* pDblT = new types::Double(*t);
    args.add_in(pDblT);

    types::Double* pDblY = new types::Double(*neq, 1);
    pDblY->set(y);
    args.add_in(pDblY);

    types::Double* pDblS = new types::Double(*neq, 1);
    pDblS->set(s);
    args.add_in(pDblS);

    for (int i = 0; i < (int)m_FArgs.size(); i++)
    {
        args.add_in(m_FArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallFFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    types::Double* pDblOutR = args.out[0]->getAs<types::Double>();
    if (pDblOutR->getSize() != *neq)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A Matrix of size %d expected.\n"), pstrName, 1, *neq);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    C2F(dcopy)(neq, pDblOutR->get(), &one, r, &one);
    *ires = 1;
}

void DifferentialEquationFunctions::callImplMacroG(int* neq, double* t, double* y, double* ml, double* mu, double* p, int* nrowp)
{
    char errorMsg[256];
    int one         = 1;
    int iRetCount   = 1;

    args_t args;

    types::Double* pDblT = new types::Double(*t);
    args.add_in(pDblT);

    types::Double* pDblY = new types::Double(*neq, 1);
    pDblY->set(y);
    args.add_in(pDblY);

    types::Double* pDblP = new types::Double(*nrowp, *neq);
    pDblP->set(p);
    args.add_in(pDblP);

    for (int i = 0; i < (int)m_odeGArgs.size(); i++)
    {
        args.add_in(m_odeGArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallGFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallGFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallGFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    types::Double* pDblOutP = args.out[0]->getAs<types::Double>();
    if (pDblOutP->getCols() != *neq || pDblOutP->getRows() != *nrowp)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallGFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A matrix of size %d x %d expected.\n"), pstrName, 1, *neq, *nrowp);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    int size = *neq **nrowp;
    C2F(dcopy)(&size, pDblOutP->get(), &one, p, &one);
}

void DifferentialEquationFunctions::callImplMacroJac(int* neq, double* t, double* y, double* s, double* ml, double* mu, double* p, int* nrowp)
{
    char errorMsg[256];
    int one         = 1;
    int iRetCount   = 1;

    args_t args;

    types::Double* pDblT = new types::Double(*t);
    args.add_in(pDblT);

    types::Double* pDblY = new types::Double(*neq, 1);
    pDblY->set(y);
    args.add_in(pDblY);

    types::Double* pDblS = new types::Double(*neq, 1);
    pDblS->set(s);
    args.add_in(pDblS);

    for (int i = 0; i < (int)m_JacArgs.size(); i++)
    {
        args.add_in(m_JacArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallJacFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallJacFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallJacFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    types::Double* pDblOutP = args.out[0]->getAs<types::Double>();
    if (pDblOutP->getCols() != *neq || pDblOutP->getRows() != *nrowp)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallJacFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A matrix of size %d x %d expected.\n"), pstrName, 1, *neq, *nrowp);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    int size = *neq **nrowp;
    C2F(dcopy)(&size, pDblOutP->get(), &one, p, &one);
}

void DifferentialEquationFunctions::callDasslMacroF(double* t, double* y, double* ydot, double* delta, int* ires, double* rpar, int* ipar)
{
    char errorMsg[256];
    int one         = 1;
    int iRetCount   = 2;

    args_t args;

    types::Double* pDblT = new types::Double(*t);
    args.add_in(pDblT);

    types::Double* pDblY = new types::Double(m_odeYRows, 1);
    pDblY->set(y);
    args.add_in(pDblY);

    types::Double* pDblYdot = new types::Double(m_odeYRows, 1);
    pDblYdot->set(ydot);
    args.add_in(pDblYdot);

    for (int i = 0; i < (int)m_FArgs.size(); i++)
    {
        args.add_in(m_FArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallFFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[1]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 2);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    types::Double* pDblOutDelta = args.out[0]->getAs<types::Double>();
    if (pDblOutDelta->getSize() != m_odeYRows)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A matrix of size %d expected.\n"), pstrName, 1, m_odeYRows);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    types::Double* pDblOutIres = args.out[1]->getAs<types::Double>();
    if (pDblOutIres->getSize() != 1)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallFFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A Scalar expected.\n"), pstrName, 2);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    C2F(dcopy)(&m_odeYRows, pDblOutDelta->get(), &one, delta, &one);
    *ires = (int)pDblOutIres->get(0);
}

void DifferentialEquationFunctions::callDasslMacroJac(double* t, double* y, double* ydot, double* pd, double* cj, double* rpar, int* ipar)
{
    char errorMsg[256];
    int one         = 1;
    int iRetCount   = 1;

    args_t args;

    types::Double* pDblT = new types::Double(*t);
    args.add_in(pDblT);

    types::Double* pDblY = new types::Double(m_odeYRows, 1);
    pDblY->set(y);
    args.add_in(pDblY);

    types::Double* pDblYdot = new types::Double(m_odeYRows, 1);
    pDblYdot->set(ydot);
    args.add_in(pDblYdot);

    types::Double* pDblCj = new types::Double(*cj);
    args.add_in(pDblCj);

    for (int i = 0; i < (int)m_JacArgs.size(); i++)
    {
        args.add_in(m_JacArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallJacFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallJacFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }
    
    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallJacFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    types::Double* pDblOutPd = args.out[0]->getAs<types::Double>();
    if ( (pDblOutPd->getCols() != m_odeYRows) ||
            (!m_bandedJac && pDblOutPd->getRows() != m_odeYRows) ||
            (m_bandedJac && pDblOutPd->getRows() != (2 * m_ml + m_mu + 1)))
    {
        char* pstrName = wide_string_to_UTF8(m_pCallJacFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A matrix of size %d x %d expected.\n"), pstrName, 1, m_odeYRows, (2 * m_ml + m_mu + 1));
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    int size = pDblOutPd->getSize();
    C2F(dcopy)(&size, pDblOutPd->get(), &one, pd, &one);
}

void DifferentialEquationFunctions::callDasrtMacroG(int* ny, double* t, double* y, int* ng, double* gout, double* rpar, int* ipar)
{
    char errorMsg[256];
    int one         = 1;
    int iRetCount   = 1;

    args_t args;

    types::Double* pDblT = new types::Double(*t);
    args.add_in(pDblT);

    types::Double* pDblY = new types::Double(*ny, 1);
    pDblY->set(y);
    args.add_in(pDblY);

    for (int i = 0; i < (int)m_odeGArgs.size(); i++)
    {
        args.add_in(m_odeGArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallGFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallGFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallGFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    types::Double* pDblOutGout = args.out[0]->getAs<types::Double>();
    if (pDblOutGout->getSize() != *ng)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallGFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A matrix of size %d expected.\n"), pstrName, 1, *ng);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    C2F(dcopy)(ng, pDblOutGout->get(), &one, gout, &one);
}

void DifferentialEquationFunctions::callDaskrMacroG(int* ny, double* t, double* y, double* ydot, int* ng, double* gout, double* rpar, int* ipar)
{
    char errorMsg[256];
    int one         = 1;
    int iRetCount   = 1;

    args_t args;

    types::Double* pDblT = new types::Double(*t);
    args.add_in(pDblT);

    types::Double* pDblY = new types::Double(*ny, 1);
    pDblY->set(y);
    args.add_in(pDblY);

    types::Double* pDblYdot = new types::Double(*ny, 1);
    pDblYdot->set(ydot);
    args.add_in(pDblYdot);

    for (int i = 0; i < (int)m_odeGArgs.size(); i++)
    {
        args.add_in(m_odeGArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallGFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallGFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallGFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    types::Double* pDblOutGout = args.out[0]->getAs<types::Double>();
    if (pDblOutGout->getSize() != *ng)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallGFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A matrix of size %d expected.\n"), pstrName, 1, *ng);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    C2F(dcopy)(ng, pDblOutGout->get(), &one, gout, &one);
}

void DifferentialEquationFunctions::callDaskrMacroPjac(double* res, int* ires, int* neq, double* t, double* y, double* ydot,
        double* rewt, double* savr, double* wk, double* h, double* cj,
        double* wp, int* iwp, int* ier, double* rpar, int* ipar)
{
    // macro : [R, iR, ier] = psol(neq, t, y, ydot, h, cj, rewt, savr)
    char errorMsg[256];
    int one         = 1;
    int iRetCount   = 3;

    args_t args;
    
    types::Double* pDblNeq = new types::Double((double)(*neq));
    args.add_in(pDblNeq);

    types::Double* pDblT = new types::Double(*t);
    args.add_in(pDblT);

    types::Double* pDblY = new types::Double(m_odeYRows, 1);
    pDblY->set(y);
    args.add_in(pDblY);

    types::Double* pDblYdot = new types::Double(m_odeYRows, 1);
    pDblYdot->set(ydot);
    args.add_in(pDblYdot);

    types::Double* pDblH = new types::Double(*h);
    args.add_in(pDblH);

    types::Double* pDblCj = new types::Double(*cj);
    args.add_in(pDblCj);

    types::Double* pDblRewt = new types::Double(m_odeYRows, 1);
    pDblRewt->set(rewt);
    args.add_in(pDblRewt);

    types::Double* pDblSavr = new types::Double(m_odeYRows, 1);
    pDblSavr->set(savr);
    args.add_in(pDblSavr);

    for (int i = 0; i < (int)m_pJacArgs.size(); i++)
    {
        args.add_in(m_pJacArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallPjacFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallPjacFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    // check type of output arguments
    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallPjacFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[1]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallPjacFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 2);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[2]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallPjacFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 3);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    //  return [R, iR, ier]
    types::Double* pDblOutWp  = args.out[0]->getAs<types::Double>();
    types::Double* pDblOutIwp = args.out[1]->getAs<types::Double>();
    types::Double* pDblOutIer = args.out[2]->getAs<types::Double>();

    // check size of output argument
    if (pDblOutWp->getSize() != *neq **neq)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallPjacFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A matrix of size %d expected.\n"), pstrName, 1, *neq **neq);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (pDblOutIwp->getSize() != 2 * *neq **neq)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallPjacFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A matrix of size %d expected.\n"), pstrName, 2, 2 * *neq **neq);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (pDblOutIer->isScalar() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallPjacFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A Scalar expected.\n"), pstrName, 3);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    // copy output macro results in output variables
    int size = pDblOutWp->getSize();
    C2F(dcopy)(&size, pDblOutWp->get(), &one, wp, &one);

    double* pdblIwp = pDblOutIwp->get();
    for (int i = 0; i < pDblOutIwp->getSize(); i++)
    {
        iwp[i] = (int)pdblIwp[i];
    }

    *ier = (int)(pDblOutIer->get(0));
}

void DifferentialEquationFunctions::callDaskrMacroPsol(int* neq, double* t, double* y, double* ydot, double* savr, double* wk,
        double* cj, double* wght, double* wp, int* iwp, double* b, double* eplin,
        int* ier, double* rpar, int* ipar)
{
    // macro : [b, ier] = psol(R, iR, b)
    char errorMsg[256];
    int one         = 1;
    int iRetCount   = 2;

    args_t args;
    
    // input arguments psol(R, iR, b)
    types::Double* pDblR = new types::Double(*neq **neq, 1);
    pDblR->set(wp);
    args.add_in(pDblR);

    types::Double* pDblIR = new types::Double(*neq **neq, 2);
    double* pdblIR = pDblIR->get();
    for (int i = 0; i < pDblIR->getSize(); i++)
    {
        pdblIR[i] = (double)iwp[i];
    }
    args.add_in(pDblIR);

    types::Double* pDblB = new types::Double(*neq, 1);
    pDblB->set(b);
    args.add_in(pDblB);

    // optional arguments
    for (int i = 0; i < (int)m_pSolArgs.size(); i++)
    {
        args.add_in(m_pSolArgs[i]);
    }

    try
    {
        // new std::wstring(L"") is delete in destructor of ast::CommentExp
        m_pCallPsolFunction->invoke(args.in, args.opt, iRetCount, args.out, ast::CommentExp(Location(), new std::wstring(L"")));
    }
    catch (const ast::InternalError& ie)
    {
        throw ie;
    }

    // get output
    if (args.out.size() != iRetCount)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallPsolFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), pstrName, iRetCount);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    // check output result
    if (args.out[0]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallPsolFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 1);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    if (args.out[1]->isDouble() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallPsolFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong type for output argument #%d: Real matrix expected.\n"), pstrName, 2);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    // return arguments [b, ier] = psol()
    types::Double* pDblOutB  = args.out[0]->getAs<types::Double>();
    if (pDblOutB->getSize() != *neq) // size of b is neq
    {
        char* pstrName = wide_string_to_UTF8(m_pCallPsolFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A matrix of size %d expected.\n"), pstrName, 1, *neq);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    // get scalar ier
    types::Double* pDblOutIer = args.out[1]->getAs<types::Double>();
    if (pDblOutIer->isScalar() == false)
    {
        char* pstrName = wide_string_to_UTF8(m_pCallPsolFunction->getName().c_str());
        sprintf(errorMsg, _("%s: Wrong size for output argument #%d: A Scalar expected.\n"), pstrName, 2);
        FREE(pstrName);
        throw ast::InternalError(errorMsg);
    }

    // copy output macro results in output variables
    C2F(dcopy)(neq, pDblOutB->get(), &one, b, &one);
    *ier = (int)(pDblOutIer->get(0));
}
