// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
// Copyright (C) 2015 - Scilab-Enterprises - Cedric Delamarre
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 7601 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7601
//
// <-- Short Description -->
// call_scilab C functions did not check if engine is started.

// Create a C code to use call_scilab:

#ifdef _MSC_VER
#pragma comment(lib, "call_scilab.lib")
#endif

#include <stdlib.h>
#include <stdio.h>
#include "call_scilab.h"

int main(void)
{
#ifdef _MSC_VER
    StartScilab(NULL, NULL, 0);
#else
    StartScilab(getenv("SCI"), NULL, 0);
#endif
    SendScilabJob("disp([2,3]+[-44,39]);"); // Will display   - 42.    42.
    TerminateScilab(NULL);
    return SendScilabJob("disp([2,3]+[-44,39]);");
}
