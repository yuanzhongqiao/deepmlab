/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) INRIA
 * ...
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

/* C driver over ddassl to handle longjump from xerhlt*/
#include "xerhlt.h"
#include "dynlib_differential_equations.h"


extern void C2F(ddassl)(void *res, int *neq, double *t, double *y, double *yprime,
                        double *tout, int *info, double *rtol, double *atol,
                        int *idid, double *rwork, int *lrw, int *iwork, int *liw,
                        double *rpar, int *ipar, void *jac);


DIFFERENTIAL_EQUATIONS_IMPEXP void  C2F(dassl)(void *res, int *neq, double *t, double *y, double *yprime, double *tout,
        int *info, double *rtol, double *atol, int *idid, double *rwork,
        int *lrw, int *iwork, int *liw, double *rpar, int *ipar, void *jac);

void  C2F(dassl)(void *res, int *neq, double *t, double *y, double *yprime, double *tout,
                 int *info, double *rtol, double *atol, int *idid, double *rwork,
                 int *lrw, int *iwork, int *liw, double *rpar, int *ipar, void *jac)
{
    C2F(ddassl)(res, neq, t, y, yprime, tout, info, rtol, atol, idid, rwork,
                lrw, iwork, liw, rpar, ipar, jac);
}

