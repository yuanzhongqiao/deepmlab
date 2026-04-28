/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) Scilab Enterprises - 2012 - Paul Bignier
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

#ifndef _LSODAR_H
#define _LSODAR_H

#include "sundials/sundials_extension.h"
#include "sundials/sundials_types.h" // Definition of types 'sunrealtype' and 'booleantype'
#include "nvector/nvector_serial.h"  // Type 'N_Vector'
#include "../src/cvodes/cvodes_impl.h" // Error handling

#define MSGCV_BAD_INPUT      "One of the arguments is illegal."

#ifndef max
#define max(A,B) ((A>B) ? A:B)  // 'max()' function
#endif

// sunrealtype workspace
struct rWork_t
{
    sunrealtype tcrit;
    sunrealtype rwork2;
    sunrealtype rwork3;
    sunrealtype rwork4;
    sunrealtype h0;
    sunrealtype hmax;
    sunrealtype hmin;
    sunrealtype rwork[1];
};

// Derivative computation and Root functions
typedef void (*LSRhsFn) (int * neq, sunrealtype * t, sunrealtype * y, sunrealtype * rwork);
typedef void (*LSRootFn) (int * neq, sunrealtype * t, sunrealtype * y, int * ng, sunrealtype * rwork);
typedef void (*LSErrHandlerFn) (int error_code, const char *module, const char *function, char *msg, void *user_data);

// LSodar problem memory structure
typedef struct LSodarMemRec
{
    LSRhsFn func;
    int * nEquations;
    sunrealtype * yVector;
    sunrealtype tStart;
    sunrealtype tEnd;
    int iTol;
    sunrealtype relTol;
    sunrealtype absTol;
    int iState;
    int iOpt;
    struct rWork_t * rwork;
    int lrw;
    int * iwork;
    int liw;
    int jacobian;
    int jacType;
    LSRootFn g_fun;
    int ng_fun;
    int * jroot;
    LSErrHandlerFn ehfun;
} *LSodarMem;

// Creating the problem
void * LSodarCreate (int * neq, int ng);

// Allocating the problem
int LSodarInit (void * lsodar_mem, LSRhsFn f, sunrealtype t0, N_Vector y);

// Reinitializing the problem
int LSodarReInit (void * lsodar_mem, sunrealtype tOld, N_Vector y);

// Specifying the tolerances
int LSodarSStolerances (void * lsodar_mem, sunrealtype reltol, sunrealtype abstol);

// Initializing the root-finding problem
int LSodarRootInit (void * lsodar_mem, int ng, LSRootFn g);

// Specifying the maximum step size
int LSodarSetMaxStep (void * lsodar_mem, sunrealtype hmax);

// Specifying the time beyond which the integration is not to proceed
int LSodarSetStopTime (void * lsodar_mem, sunrealtype tcrit);

// Solving the problem
int LSodar (void * lsodar_mem, sunrealtype tOut, N_Vector yVec, sunrealtype * tOld, int itask);

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

#endif
