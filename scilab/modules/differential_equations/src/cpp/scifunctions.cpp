/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
* Copyright (C) 2011 - DIGITEO - Cedric DELAMARRE
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
#include "differentialequationfunctions.hxx"

extern "C"
{
#include "scifunctions.h"
#include "common_structure.h"
}

int* ierode_ierror = &(C2F(ierode).iero);
int* ierdassl_ierror = &(C2F(ierdassl).iero);
int* ierajf_ierror = &(C2F(ierajf).iero);

// ode / odedc
void ode_f(int* n, double* t, double* y, double* ydot)
{
    DifferentialEquationFunctions* deFunction = NULL;
    deFunction = DifferentialEquation::getDifferentialEquationFunctions();

    try
    {
        if (deFunction == NULL)
        {
            throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
        }

        deFunction->execOdeF(n, t, y, ydot);
    }
    catch (const ast::InternalError&)
    {
        *ierode_ierror = 1;
    }
}

void ode_jac(int *n, double *t, double *y, int *ml, int *mu, double *J, int *nrpd)
{
    DifferentialEquationFunctions* deFunction = NULL;
    deFunction = DifferentialEquation::getDifferentialEquationFunctions();
    try
    {
        if (deFunction == NULL)
        {
            throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
        }

        deFunction->execFunctionJac(n, t, y, ml, mu, J, nrpd);
    }
    catch (const ast::InternalError&)
    {
        *ierode_ierror = 1;
    }
}

void ode_g(int* n, double* t, double* y, int* ng, double* gout)
{
    DifferentialEquationFunctions* deFunction = NULL;
    deFunction = DifferentialEquation::getDifferentialEquationFunctions();

    try
    {
        if (deFunction == NULL)
        {
            throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
        }

        deFunction->execFunctionG(n, t, y, ng, gout);
    }
    catch (const ast::InternalError&)
    {
        *ierode_ierror = 1;
    }
}

// intg
double intg_f(double* x)
{
    DifferentialEquationFunctions* deFunction = NULL;
    deFunction = DifferentialEquation::getDifferentialEquationFunctions();

    try
    {
        if (deFunction == NULL)
        {
            throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
        }

        return deFunction->execIntgF(x);
    }
    catch (const ast::InternalError&)
    {
        *ierajf_ierror = 1;
        return NAN;
    }
}

// int2d
double int2d_f(double* x, double* y)
{
    DifferentialEquationFunctions* deFunction = NULL;
    deFunction = DifferentialEquation::getDifferentialEquationFunctions();

    if (deFunction == NULL)
    {
        throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
    }

    return deFunction->execInt2dF(x, y);
}

// int3d
void int3d_f(double* x, int* numfun, double* funvls)
{
    DifferentialEquationFunctions* deFunction = NULL;
    deFunction = DifferentialEquation::getDifferentialEquationFunctions();

    if (deFunction == NULL)
    {
        throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
    }

    deFunction->execInt3dF(x, numfun, funvls);
}

// bvode
void bvode_gsub(int* i, double* z, double* g)
{
    DifferentialEquationFunctions* deFunction = NULL;
    deFunction = DifferentialEquation::getDifferentialEquationFunctions();

    if (deFunction == NULL)
    {
        throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
    }

    deFunction->execBvodeGsub(i, z, g);
}
void bvode_dgsub(int* i, double* z, double* g)
{
    DifferentialEquationFunctions* deFunction = NULL;
    deFunction = DifferentialEquation::getDifferentialEquationFunctions();

    if (deFunction == NULL)
    {
        throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
    }

    deFunction->execBvodeDgsub(i, z, g);
}
void bvode_fsub(double* x, double* z, double* d)
{
    DifferentialEquationFunctions* deFunction = NULL;
    deFunction = DifferentialEquation::getDifferentialEquationFunctions();

    if (deFunction == NULL)
    {
        throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
    }

    deFunction->execBvodeFsub(x, z, d);
}
void bvode_dfsub(double* x, double* z, double* d)
{
    DifferentialEquationFunctions* deFunction = NULL;
    deFunction = DifferentialEquation::getDifferentialEquationFunctions();

    if (deFunction == NULL)
    {
        throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
    }

    deFunction->execBvodeDfsub(x, z, d);
}
void bvode_guess(double* x, double* z, double* d)
{
    DifferentialEquationFunctions* deFunction = NULL;
    deFunction = DifferentialEquation::getDifferentialEquationFunctions();

    if (deFunction == NULL)
    {
        throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
    }

    deFunction->execBvodeGuess(x, z, d);
}

// impl
void impl_f(int* neq, double* t, double* y, double* s, double* r, int* ires)
{
    DifferentialEquationFunctions* deFunction = NULL;
    deFunction = DifferentialEquation::getDifferentialEquationFunctions();

    try
    {
        if (deFunction == NULL)
        {
            throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
        }

        deFunction->execImplF(neq, t, y, s, r, ires);
    }
    catch (const ast::InternalError&)
    {
        *ierode_ierror = 1;
    }
}
void impl_g(int* neq, double* t, double* y, double* ml, double* mu, double* p, int* nrowp)
{
    DifferentialEquationFunctions* deFunction = NULL;
    deFunction = DifferentialEquation::getDifferentialEquationFunctions();

    try
    {
        if (deFunction == NULL)
        {
            throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
        }

        deFunction->execImplG(neq, t, y, ml, mu, p, nrowp);
    }
    catch (const ast::InternalError&)
    {
        *ierode_ierror = 1;
    }
}
void impl_jac(int* neq, double* t, double* y, double* s, double* ml, double* mu, double* p, int* nrowp)
{
    DifferentialEquationFunctions* deFunction = NULL;
    deFunction = DifferentialEquation::getDifferentialEquationFunctions();

    try
    {
        if (deFunction == NULL)
        {
            throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
        }

        deFunction->execImplJac(neq, t, y, s, ml, mu, p, nrowp);
    }
    catch (const ast::InternalError&)
    {
        *ierode_ierror = 1;
    }
}

// dassl, dasrt, daskr
void dassl_f(double* t, double* y, double* ydot, double* delta, int* ires, double* rpar, int* ipar)
{
    DifferentialEquationFunctions* deFunction = NULL;
    try
    {
        deFunction = DifferentialEquation::getDifferentialEquationFunctions();

        if (deFunction == NULL)
        {
            throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
        }

        deFunction->execDasslF(t, y, ydot, delta, ires, rpar, ipar);
    }
    catch (const ast::InternalError&)
    {
        *ierdassl_ierror = 1;
        *ierode_ierror = 1;
    }
}
void dassl_jac(double* t, double* y, double* ydot, double* pd, double* cj, double* rpar, int* ipar)
{
    DifferentialEquationFunctions* deFunction = NULL;
    try
    {
        deFunction = DifferentialEquation::getDifferentialEquationFunctions();

        if (deFunction == NULL)
        {
            throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
        }

        deFunction->execDasslJac(t, y, ydot, pd, cj, rpar, ipar);
    }
    catch (const ast::InternalError&)
    {
        *ierdassl_ierror = 1;
    }
}

// dasrt
void dasrt_g(int* ny, double* t, double* y, int* ng, double* gout, double* rpar, int* ipar)
{
    DifferentialEquationFunctions* deFunction = NULL;
    try
    {
        deFunction = DifferentialEquation::getDifferentialEquationFunctions();

        if (deFunction == NULL)
        {
            throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
        }

        deFunction->execDasrtG(ny, t, y, ng, gout, rpar, ipar);
    }
    catch (const ast::InternalError&)
    {
        *ierdassl_ierror = 1;
        *ierode_ierror = 1;
    }
}

//daskr
void daskr_g(int* ny, double* t, double* y, double* ydot, int* ng, double* gout, double* rpar, int* ipar)
{
    DifferentialEquationFunctions* deFunction = NULL;
    deFunction = DifferentialEquation::getDifferentialEquationFunctions();

    if (deFunction == NULL)
    {
        throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
    }

    deFunction->execDaskrG(ny, t, y, ydot, ng, gout, rpar, ipar);
}

void daskr_psol(int* neq, double* t, double* y, double* ydot, double* savr, double* wk,
                double* cj, double* wght, double* wp, int* iwp, double* b, double* eplin,
                int* ier, double* rpar, int* ipar)
{
    DifferentialEquationFunctions* deFunction = NULL;
    try
    {
        deFunction = DifferentialEquation::getDifferentialEquationFunctions();
        if (deFunction == NULL)
        {
            throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
        }

        deFunction->execDaskrPsol(neq, t, y, ydot, savr, wk, cj, wght, wp, iwp,
                                  b, eplin, ier, rpar, ipar);
    }
    catch (const ast::InternalError&)
    {
        *ierdassl_ierror = 1;
    }
}
void daskr_pjac(double* res, int* ires, int* neq, double* t, double* y, double* ydot,
                double* rewt, double* savr, double* wk, double* h, double* cj,
                double* wp, int* iwp, int* ier, double* rpar, int* ipar)
{
    DifferentialEquationFunctions* deFunction = NULL;

    try
    {
        deFunction = DifferentialEquation::getDifferentialEquationFunctions();
        if (deFunction == NULL)
        {
            throw ast::InternalError(_("An error occurred while getting DifferentialEquationFunctions object.\n"));
        }

        deFunction->execDaskrPjac(res, ires, neq, t, y, ydot, rewt, savr, wk, h, cj,
                                  wp, iwp, ier, rpar, ipar);
    }
    catch (const ast::InternalError&)
    {
        *ierdassl_ierror = 1;
    }

}
