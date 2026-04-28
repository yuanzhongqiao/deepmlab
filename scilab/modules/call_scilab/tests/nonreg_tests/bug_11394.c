// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Clément DAVID
// This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 11394 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/11394
//
// <-- Short Description -->
// using StartScilab, TerminateScilab and StartScilab failed in NW mode

// Create a C code to use call_scilab:

#ifdef _MSC_VER
#pragma comment(lib, "call_scilab.lib")
#endif
/*--------------------------------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include "call_scilab.h"
/*--------------------------------------------------------------------------*/
int main(void)
{
    BOOL status;
#ifdef _MSC_VER
    status = StartScilab(NULL, NULL, 0);
#else
    status = StartScilab(getenv("SCI"), NULL, 0);
#endif
    if (status != TRUE)
    {
        fprintf(stderr, "BUG 11394 NOT FIXED. (1)\n");
        return 1;
    }

    if (SendScilabJob("a = 1"))
    {
        fprintf(stderr, "BUG 11394 NOT FIXED. (3)\n");
        return 1;
    }

    status = TerminateScilab(NULL);
    if (status != TRUE)
    {
        fprintf(stderr, "BUG 11394 NOT FIXED. (4)\n");
        return 1;
    }

#ifdef _MSC_VER
    status = StartScilab(NULL, NULL, 0);
#else
    status = StartScilab(getenv("SCI"), NULL, 0);
#endif
    if (status != TRUE)
    {
        fprintf(stderr, "BUG 11394 NOT FIXED. (5)\n");
        return 1;
    }

    if (SendScilabJob("b = 1"))
    {
        fprintf(stderr, "BUG 11394 NOT FIXED. (6)\n");
        return 1;
    }

    status = TerminateScilab(NULL);
    if (status != TRUE)
    {
        fprintf(stderr, "BUG 11394 NOT FIXED. (7)\n");
        return 1;
    }

    return 0;
}
/*--------------------------------------------------------------------------*/
