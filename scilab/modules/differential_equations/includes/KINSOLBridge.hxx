//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2021-2022 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

#ifndef _KINSOLBRIDGE_HXX_
#define _KINSOLBRIDGE_HXX_

typedef int (*KIN_DynFun)(N_Vector y, N_Vector ydot, void *pManager);
typedef int (*KIN_DynJacFun)(N_Vector y, N_Vector fy, SUNMatrix J, void *user_data, N_Vector tmp1, N_Vector tmp2);
typedef int (*KIN_DynCallback)(int iFlag, N_Vector y, double *);

static std::map<int, std::wstring> wstrCbState = {{-1,L"init"}, {0,L"step"}, {1,L"done"}};

#endif
