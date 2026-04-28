//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

#include <nvector/nvector_serial.h>    /* access to serial N_Vector       */
#include <sunmatrix/sunmatrix_dense.h> /* access to dense SUNmatrix       */
#include "sciprint.h"

// CVODE entrypoints for unit tests in SCI/sundials/tests/unit_tests/cvode.tst

int SUN_dynrhs(sunrealtype t, N_Vector Y, N_Vector Yd, void *user_data)
{
    double *y = NV_DATA_S(Y);
    double *yd = NV_DATA_S(Yd);
    yd[0] = y[1];
    yd[1] = (1-y[0]*y[0])*y[1]-y[0];
    return 0;
}

int SUN_dynrhspar(sunrealtype t, N_Vector Y, N_Vector Yd, void *user_data)
{
    double *y = NV_DATA_S(Y);
    double *yd = NV_DATA_S(Yd);
    double *mu = (double *)user_data;
    yd[0] = y[1];
    yd[1] = mu[0]*(1-y[0]*y[0])*y[1]-y[0];
    return 0;
}

int SUN_dynjac(sunrealtype t, N_Vector Y, N_Vector Yd, SUNMatrix J, 
    void *user_data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3)
{
    double *y = NV_DATA_S(Y);
    double *jac = SM_DATA_D(J);
    jac[0] = 0; jac[1] = -2*y[0]*y[1]-1;
    jac[2] = 1.0; jac[3] = 1-y[0]*y[0];
    return 0;
}

int SUN_dynjacpar(sunrealtype t, N_Vector Y, N_Vector Yd, SUNMatrix J, 
    void *user_data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3)
{
    double *y = NV_DATA_S(Y);
    double *jac = SM_DATA_D(J);
    double *mu = (double *)user_data;
    jac[0]=0; jac[1]=-2.0*mu[0]*y[0]*y[1]-1.0;
    jac[2]=1.0; jac[3]=mu[0]*(1.0-y[0]*y[0]);
    return 0;
}

int SUN_dyncb(sunrealtype t, int iFlag, N_Vector N_VectorY, void *user_data)
{
    sciprint("flag=%d\n", iFlag);
    return 0;
}

int SUN_dynevent(sunrealtype t, N_Vector Y, sunrealtype *gout, void *user_data)
{ 
    double *y = NV_DATA_S(Y);
    gout[0] = y[0]-1.7;
    return 0;
}

int SUN_dyneventpar(sunrealtype t, N_Vector Y, sunrealtype *gout, void *user_data)
{ 
    double *y = NV_DATA_S(Y);
    double *par = (double *)user_data;
    gout[0] = y[0]-par[0];
    return 0;
}

// IDA entrypoints for unit tests in SCI/sundials/tests/unit_tests/ida.tst

int SUN_chemres(sunrealtype t, N_Vector Y, N_Vector Yd, N_Vector R, void *user_data)
{
    double *y = NV_DATA_S(Y);
    double *yd = NV_DATA_S(Yd);
    double *r =  NV_DATA_S(R);
    r[0] = yd[0]+0.04*y[0]-1.0e4*y[1]*y[2];
    r[1] = yd[1]-0.04*y[0]+1.0e4*y[1]*y[2]+3.0e7*y[1]*y[1];
    r[2] = y[0]+y[1]+y[2]-1;
    return 0;
}

int SUN_chemjac(sunrealtype t, sunrealtype cj, N_Vector Y, N_Vector Yd, N_Vector R, SUNMatrix J,
    void *user_data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3)
{
    double *y = NV_DATA_S(Y);
    double *jac = SM_DATA_D(J);
    /* first column*/
    jac[0] = 0.04+cj;
    jac[1] =  -0.04;
    jac[2] =  1.0;
    /* second column*/
    jac[3] =  -1.0e4*y[2];
    jac[4] = +1.0e4*y[2]+2*3.0e7*y[1]+cj;
    jac[5] =  1.0;
    /* third column*/
    jac[6] =  -1.0e4*y[1];
    jac[7] = +1.0e4*y[1];
    jac[8] =  1.0;
    return 0;
}

int SUN_chemevent(sunrealtype t, N_Vector Y, N_Vector Yd, sunrealtype *gout, void *user_data)
{
    double *yd = NV_DATA_S(Yd);
    gout[0] = yd[1];
    return 0;
}

int SUN_chemcb(sunrealtype t, int iFlag, N_Vector Y, N_Vector Yd, void *user_data)
{
    double *y = NV_DATA_S(Y);
    double *yd = NV_DATA_S(Yd);
    sciprint("t=%f, y2=%e, yp2=%e\n",t,y[1],yd[1]);
    return 0;
}
