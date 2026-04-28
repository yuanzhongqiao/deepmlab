//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2021-2023 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

#ifndef _SUNDIALSBRIDGE_HXX_
#define _SUNDIALSBRIDGE_HXX_

typedef int (*SUN_DynFun)(sunrealtype t, N_Vector y, N_Vector ydot, void *pManager);
typedef int (*SUN_DynJacFun)(sunrealtype t, N_Vector y, N_Vector fy, SUNMatrix J, void *user_data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3);
typedef int (*SUN_DynRes)(sunrealtype t, N_Vector y, N_Vector ydot, N_Vector res, void *pManager);
typedef int (*SUN_DynSensRes)(int Ns, sunrealtype t, N_Vector N_VectorY, N_Vector ydot, N_Vector resval, N_Vector *yS, N_Vector *ySdot, N_Vector *resvalS, void *pmanager, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3);
typedef int (*SUN_DynJacRes)(sunrealtype t, sunrealtype c, N_Vector y, N_Vector yp, N_Vector r, SUNMatrix J, void *user_data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3);
typedef int (*SUN_DynMass)(sunrealtype t, SUNMatrix M, void *user_data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3);
typedef int (*SUN_DynProj)(sunrealtype t, N_Vector N_VectorY, N_Vector N_VectorCorr, sunrealtype epsProj, N_Vector N_VectorErr, void *pmanager);
typedef int (*SUN_DynEvent)(sunrealtype t, N_Vector y, sunrealtype *gout, void *pManager);
typedef int (*SUN_DynSensRhs)(int Ns, sunrealtype t, N_Vector N_VectorY, N_Vector ydot, N_Vector *yS, N_Vector *ySdot, void *pmanager, N_Vector tmp1, N_Vector tmp2);
typedef int (*SUN_DynImplEvent)(sunrealtype t, N_Vector N_VectorY, N_Vector N_VectorYp, sunrealtype *pdblOut, void *pManager);
typedef int (*SUN_DynCallBack)(sunrealtype t, int iFlag, N_Vector N_VectorY, void *pManager);
typedef int (*SUN_DynImplCallBack)(sunrealtype t, int iFlag, N_Vector N_VectorY, N_Vector N_VectorYp, void *pManager);

static std::map<int, std::wstring> wstrCbState = {{-1,L"init"}, {0,L"step"}, {1,L"event"}, {2,L"done"}};

#endif
