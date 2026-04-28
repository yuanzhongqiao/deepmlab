/*--------------------------------------------------------------------------*/
/* Example only for Windows */
/*--------------------------------------------------------------------------*/
#pragma comment(lib, "../../../../../../bin/call_scilab.lib")
#pragma comment(lib, "../../../../../../bin/api_scilab.lib")
/*--------------------------------------------------------------------------*/
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "call_scilab.h"
#include "api_scilab.h"
/*--------------------------------------------------------------------------*/
/* See SCI/modules/core/includes/call_scilab.h */
/* See SCI/modules/core/includes/api_scilab.h */
/*--------------------------------------------------------------------------*/
void pause()
{
    wprintf(L"Press [return] to continue.");
    int c = getwchar();
}

static int example1(void)
{
    static double A[] = {1, 2, 3, 4};
    int dimsA[] = {2, 2};

    static double B[] = {4, 5};
    int dimsB[] = {2, 1};

    /* Create Scilab matrices A and b */
    scilabVar varA = scilab_createDoubleMatrix(NULL, 2, dimsA, 0);
    if (varA == NULL)
    {
        wprintf(L"Error occurred during scilab execution (scilab_createDoubleMatrix)\n");
        return 1;
    }

    scilab_setDoubleArray(NULL, varA, A);
    scilab_setVar(L"A", varA);

    scilabVar varB = scilab_createDoubleMatrix(NULL, 2, dimsB, 0);
    if (varB == NULL)
    {
        wprintf(L"Error occurred during scilab execution (scilab_createDoubleMatrix)\n");
        return 1;
    }

    scilab_setDoubleArray(NULL, varB, B);
    scilab_setVar(L"B", varB);

    SendScilabJob("disp('A=');");
    SendScilabJob("disp(A);");
    SendScilabJob("disp('B=');");
    SendScilabJob("disp(B);");
    SendScilabJob("disp('x=A\\B');");

    if (SendScilabJob("A,B,X=A\\B;") != 0)
    {
        wprintf(L"Error occurred during scilab execution (SendScilabJob)\n");
    }
    else
    {
        int rowX, colX;
        double* dataX = NULL;
        scilabVar varX = scilab_getVar(L"X");
        scilab_getDim2d(NULL, varX, &rowX, &colX);
        scilab_getDoubleArray(NULL, varX, &dataX);

        for (int i = 0; i < rowX * colX; i++)
        {
            wprintf(L"x[%d] = %5.2f\n", i, dataX[i]);
        }
    }
    return 0;
}
/*--------------------------------------------------------------------------*/
static int example2(void)
{
    SendScilabJob("plot3d();");
    wprintf(L"\nClose Graphical Windows to close this example.\n");
    while (ScilabHaveAGraph());
    return 1;
}
/*--------------------------------------------------------------------------*/
static int example3(void)
{
#define JOB_SIZE 6
    char* JOBS[JOB_SIZE] = {
        "A=1 ...",
        "+3;",
        "B = 8;",
        "+3;",
        "disp('C=');",
        "C=A+B;disp(C);"
    };

    if (SendScilabJobs(JOBS, JOB_SIZE))
    {
        char lastjob[4096]; // bsiz in scilab 4096 max
        if (GetLastJob(lastjob, 4096))
        {
            wprintf(L"Error %hs\n", lastjob);
        }
    }
    return 1;
}
/*--------------------------------------------------------------------------*/
int main(void)
/* int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance,LPSTR szCmdLine, int iCmdShow) */
{
    if ( StartScilab(NULL, NULL, 0) == FALSE )
    {
        wprintf(L"Error : StartScilab\n");
        return 0;
    }

    wprintf(L"example 1\n");
    example1();
    pause();
    wprintf(L"example 2\n");
    example2();
    wprintf(L"example 3\n");
    example3();
    pause();

    if ( TerminateScilab(NULL) == FALSE )
    {
        wprintf(L"Error : TerminateScilab\n");
    }
    return 0;
}
/*--------------------------------------------------------------------------*/
