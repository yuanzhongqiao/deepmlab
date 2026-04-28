// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Sylvestre LEDRU
// Copyright (C) 2015 - Scilab-Enterprises - Cedric Delamarre
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 8830 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8830
//
// <-- Short Description -->
// In call_scilab, TerminateScilab  did not clear the last error.

// Create a C code to use call_scilab:

#ifdef _MSC_VER
#pragma comment(lib, "call_scilab.lib")
#endif

#include <stdio.h>
#include <stdlib.h>
#include "call_scilab.h" /* Provide functions to call Scilab engine */

/*------------------------------------------------------------*/
int main(void)
{
    DisableInteractiveMode();

#ifdef _MSC_VER
    if (StartScilab(NULL, NULL, 0) == FALSE)
#else
    if (StartScilab(getenv("SCI"), NULL, 0) == FALSE)
#endif
    {
        fprintf(stderr, "Error while calling StartScilab\n");
        return -1;
    }

    SendScilabJob("error(\"my own error\")");
    char* msg = getLastErrorMessageSingle();
    printf("%s\n", msg);
    free(msg);

    if (TerminateScilab(NULL) == FALSE)
    {
        fprintf(stderr, "Error while calling TerminateScilab\n");
        return -2;
    }

    printf("getLastErrorValue %d\n", getLastErrorValue());
    return 0;
}
/*------------------------------------------------------------*/
