/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) Scilab Enterprises - 2013 - Paul Bignier
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

#ifndef _DDASKR_H
#define _DDASKR_H

#include "sundials/sundials_extension.h"
#include "sundials/sundials_types.h" // Definition of types 'sunrealtype' and 'booleantype'
#include "nvector/nvector_serial.h"  // Type 'N_Vector'

#define MSG_BAD_KRY_INPUT  "One of the Krylov arguments is illegal (jacobian or psol functions)."
#define MSG_SINGULAR       "The matrix of partial derivatives is singular."
#define MSG_BAD_INPUT      "One of the arguments is illegal."

#ifndef max
#define max(A,B) ((A>B) ? A:B)  // 'max()' function
#endif

/* By default, we set the maximum order to 5 */
#define MAXORD_DEFAULT 5

// sunrealtype workspace
struct DDrWork_t
{
    sunrealtype tcrit;
    sunrealtype hmax;
    sunrealtype hnext;
    sunrealtype tfarthest;
    sunrealtype rwork5;
    sunrealtype rwork6;
    sunrealtype hlast;
    sunrealtype rwork8;
    sunrealtype rwork9;
    sunrealtype rwork10;
    sunrealtype rwork11;
    sunrealtype rwork12;
    sunrealtype rwork13;
    sunrealtype steptol;
    sunrealtype epinit;
    sunrealtype rwork[1];
};

// Derivative computation, root functions, preconditioner calculation and application
typedef void (*DDASResFn) (sunrealtype *tOld, sunrealtype *y, sunrealtype *yp, sunrealtype *res, int *flag, sunrealtype *dummy1, int *dummy2);
typedef void (*DDASRootFn) (int *neq, sunrealtype *tOld, sunrealtype *y, sunrealtype *yp, int *ng, sunrealtype *groot, sunrealtype *dummy1, int *dummy2);
typedef void (*DDASJacPsolFn) (sunrealtype *res, int *ires, int *neq, sunrealtype *tOld, sunrealtype *actual, sunrealtype *actualP,
                               sunrealtype *rewt, sunrealtype *savr, sunrealtype *wk, sunrealtype *h, sunrealtype *cj, sunrealtype *wp,
                               int *iwp, int *ier, sunrealtype *dummy1, int *dummy2);
typedef void (*DDASPsolFn) (int *neq, sunrealtype *tOld, sunrealtype *actual, sunrealtype *actualP,
                            sunrealtype *savr, sunrealtype *wk, sunrealtype *cj, sunrealtype *wght, sunrealtype *wp,
                            int *iwp, sunrealtype *b, sunrealtype *eplin, int *ier, sunrealtype *dummy1, int *dummy2);
typedef void (*DDASErrHandlerFn) (int error_code, const char *module, const char *function, char *msg, void *user_data);

// DDaskr problem memory structure
typedef struct DDaskrMemRec
{
    DDASResFn res;
    int * nEquations;
    void * user_data;
    sunrealtype tStart;
    sunrealtype relTol;
    sunrealtype absTol;
    sunrealtype * yVector;
    sunrealtype * yPrimeVector;
    int iState;
    int * info;
    struct DDrWork_t * rwork;
    int lrw;
    int * iwork;
    int liw;
    int maxnhIC;
    DDASErrHandlerFn ehfun;
    DDASRootFn g_fun;
    int ng_fun;
    int * jroot;
    int solver;
    DDASJacPsolFn jacpsol;
    DDASPsolFn psol;
    sunrealtype * rpar;
    int * ipar;
} *DDaskrMem;

// Creating the problem
void * DDaskrCreate (int * neq, int ng, int solverIndex);

// Allocating the problem
int DDaskrInit (void * ddaskr_mem, DDASResFn Res, sunrealtype t0, N_Vector yy0, N_Vector yp0, DDASJacPsolFn jacpsol, DDASPsolFn psol);

// Reinitializing the problem
int DDaskrReInit (void * ddaskr_mem, sunrealtype tOld, N_Vector yy0, N_Vector yp0);

// Specifying the tolerances
int DDaskrSStolerances (void * ddaskr_mem, sunrealtype reltol, sunrealtype abstol);

// Initializing the root-finding problem
int DDaskrRootInit (void * ddaskr_mem, int ng, DDASRootFn g);

// Setting a pointer to user_data that will be passed to the user's res function every time a user-supplied function is called
int DDaskrSetUserData (void * ddaskr_mem, void * User_data);

// Specifying the maximum step size
int DDaskrSetMaxStep (void * ddaskr_mem, sunrealtype hmax);

// Specifying the time beyond which the integration is not to proceed
int DDaskrSetStopTime (void * ddaskr_mem, sunrealtype tcrit);

// Sets the maximum number of steps in an integration interval
int DDaskrSetMaxNumSteps (void * ddaskr_mem, long int maxnh);

// Sets the maximum number of Jacobian or preconditioner evaluations
int DDaskrSetMaxNumJacsIC (void * ddaskr_mem, int maxnj);

// Sets the maximum number of Newton iterations per Jacobian or preconditioner evaluation
int DDaskrSetMaxNumItersIC (void * ddaskr_mem, int maxnit);

// Sets the maximum number of values of the artificial stepsize parameter H to be tried
int DDaskrSetMaxNumStepsIC (void * ddaskr_mem, int MaxnhIC);

// Sets the flag to turn off the linesearch algorithm
int DDaskrSetLineSearchOffIC (void * ddaskr_mem, int lsoff);

// Specifying which components are differential and which ones are algrebraic, in order to get consistent initial values
int DDaskrSetId (void * ddaskr_mem, N_Vector xproperty);

// Solving the problem
int DDaskrSolve (void * ddaskr_mem, sunrealtype tOut, sunrealtype * tOld, N_Vector yOut, N_Vector ypOut, int itask);

// Computing consistent initial values for the problem
int DDaskrCalcIC (void * ddaskr_mem, int icopt, sunrealtype tout1);

// Following on DDasCalcIC, copying yy0 and yp0 (computed consistent values) into the memory space
int DDaskrGetConsistentIC (void * ddaskr_mem, N_Vector yy0, N_Vector yp0);

// Update rootsfound to the computed jroots
int DDaskrGetRootInfo (void * ddaskr_mem, int * rootsfound);

// Freeing the problem memory allocated by ddaskrMalloc
void DDaskrFree (void ** ddaskr_mem);

// Freeing the ddaskr vectors allocated in ddaskrAllocVectors
void DDASFreeVectors (DDaskrMem ddaskr_mem);

// Specifies the error handler function
int DDaskrSetErrHandlerFn (void * ddaskr_mem, DDASErrHandlerFn ehfun, void * eh_data);

// Error handling function
void DDASProcessError (DDaskrMem ddas_mem, int error_code, const char *module, const char *fname, const char *msgfmt, ...);

#endif
