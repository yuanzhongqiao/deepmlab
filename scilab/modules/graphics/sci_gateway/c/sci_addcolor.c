/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2014 - Scilab Enterprises - Antoine ELIAS
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
#include "gw_graphics.h"
#include "api_scilab.h"
#include "localization.h"
#include "Scierror.h"
#include "addColor.h"
#include "CurrentFigure.h"
#include "createGraphicObject.h"
#include "graphicObjectProperties.h"
#include "getGraphicObjectProperty.h"
#include "CurrentSubwin.h"
#include "sciprint.h"

int checkValue(double dblValue)
{
    return (dblValue >= 0.0 && dblValue <= 1.0);
}

int checkValues(double* pdblValues, int iRows)
{
    int i = 0;
    for (i = 0 ; i < iRows ; i++)
    {
        if ((checkValue(pdblValues[i]) && checkValue(pdblValues[i + iRows]) && checkValue(pdblValues[i + iRows * 2])) == 0)
        {
            return 0;
        }
    }

    return 1;
}
/*--------------------------------------------------------------------------*/
int sci_addcolor(char *fname, void* pvApiCtx)
{
    SciErr sciErr;
    int* piAddr = NULL;
    int iRows = 0;
    int iCols = 0;
    double* pdblColor = NULL;

    int iCurrentFigure = 0;
    int iCurrentSubwin = 0;
    int iColormapTarget = 0;
    int iColorMapSize = 0;
    int* piColorMapSize = &iColorMapSize;
    double* pdblReturnColor = NULL;

    CheckInputArgument(pvApiCtx, 1, 1);

    sciErr = getVarAddressFromPosition(pvApiCtx, 1, &piAddr);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        return 1;
    }

    if (isDoubleType(pvApiCtx, piAddr) == FALSE)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: Real vector 1x3 expected.\n"), fname, 1);
        return 1;
    }

    sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &iRows, &iCols, &pdblColor);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        return 1;
    }

    if (iCols != 3)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: Real vector nx3 expected.\n"), fname, 1);
        return 1;
    }

    //check values
    if (checkValues(pdblColor, iRows) == 0)
    {
        Scierror(999, _("%s: Wrong value for input argument #%d: Must be between 0.0 and 1.0.\n"), fname, 1);
        return 1;
    }

    iCurrentFigure = getCurrentFigure();
    if (iCurrentFigure == 0)
    {
        iCurrentFigure = createNewFigureWithAxes();
    }
    iCurrentSubwin = getCurrentSubWin();
    getGraphicObjectProperty(iCurrentSubwin, __GO_COLORMAP_SIZE__, jni_int, (void**)&piColorMapSize);

    if (iColorMapSize != 0)
    {
        iColormapTarget = iCurrentSubwin; 
    }
    else
    {
        iColormapTarget = iCurrentFigure;
    }

    allocMatrixOfDouble(pvApiCtx, 2, 1, iRows, &pdblReturnColor);
    addColors(iColormapTarget, pdblColor, iRows, &pdblReturnColor);

    AssignOutputVariable(pvApiCtx, 1) = 2;
    ReturnArguments(pvApiCtx);
    return 0;
}
