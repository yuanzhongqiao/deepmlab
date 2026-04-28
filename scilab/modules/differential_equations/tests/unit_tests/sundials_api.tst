// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2021 - UTC - Stéphane Mottelet
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

mputl([
"#include <nvector/nvector_serial.h>"
"int sunRhs(sunrealtype t, N_Vector N_VectorY, N_Vector N_VectorYd, void *pManager)"
"{"
"double *y = NV_DATA_S(N_VectorY);"
"double *ydot = NV_DATA_S(N_VectorYd);"
"ydot[0] = y[1];"
"ydot[1] = (1-y[0]*y[0])*y[1]-y[0];"
"return 0;"
"}"
],TMPDIR+"/code.c")
SUN_Clink("sunRhs",TMPDIR+"/code.c",load=%t);

[t,y] = cvode("sunRhs",[0 1],[0;2])
