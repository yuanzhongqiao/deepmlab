/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2006 - INRIA - Allan CORNET
 * Copyright (C) 2008 - INRIA - Vincent COUVERT (Java version)
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

extern "C"
{
#include "gw_gui.h"
#include "api_scilab.h"
#include "localization.h"
#include "CallMessageBox.h"
#include "Scierror.h"
#include "getPropertyAssignedValue.h"
#include "freeArrayOfString.h"
}
/*--------------------------------------------------------------------------*/
int sci_x_dialog(char *fname, void* pvApiCtx)
{
    SciErr sciErr;

    int nbRow = 0, nbCol = 0;
    int messageBoxID = 0;
    double* pdblEmptyMatrixAdr = NULL;

    int* piLabelsAddr = NULL;
    char** pcLabels = 0;

    int* piInitialValueAddr = NULL;
    char** pcInitialValue = 0;

    char** pcTitle = 0;

    int* piPasswordAddr = NULL;
    int iPassword = 0;

    int iUserValueSize = 0;
    char **pcUserValue = NULL;

    CheckInputArgument(pvApiCtx, 1, 3);
    CheckOutputArgument(pvApiCtx, 0, 1);

    if ((checkInputArgumentType(pvApiCtx, 1, sci_strings)))
    {
        sciErr = getVarAddressFromPosition(pvApiCtx, 1, &piLabelsAddr);
        if (sciErr.iErr)
        {
            printError(&sciErr, 0);
            return 1;
        }

        // Retrieve a matrix of string at position 1.
        if (getAllocatedMatrixOfString(pvApiCtx, piLabelsAddr, &nbRow, &nbCol, &pcLabels))
        {
            Scierror(202, _("%s: Wrong type for argument #%d: string expected.\n"), fname, 1);
            return 1;
        }
    }
    else
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: Vector of strings expected.\n"), fname, 1);
        return FALSE;
    }

    /* Create the Java Object */
    messageBoxID = createMessageBox();

    /* Title is a default title */
    setMessageBoxTitle(messageBoxID, _("Scilab Input Value Request"));

    /* Message */
    setMessageBoxMultiLineMessage(messageBoxID, pcLabels, nbCol * nbRow);
    freeAllocatedMatrixOfString(nbRow, nbCol, pcLabels);

    if (nbInputArgument(pvApiCtx) >= 2)
    {
        if (checkInputArgumentType(pvApiCtx, 2, sci_strings))
        {
            sciErr = getVarAddressFromPosition(pvApiCtx, 2, &piInitialValueAddr);
            if (sciErr.iErr)
            {
                printError(&sciErr, 0);
                return 1;
            }

            // Retrieve a matrix of string at position 2.
            if (getAllocatedMatrixOfString(pvApiCtx, piInitialValueAddr, &nbRow, &nbCol, &pcInitialValue))
            {
                Scierror(202, _("%s: Wrong type for argument #%d: string expected.\n"), fname, 2);
                return 1;
            }
        }
        else
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: Vector of strings expected.\n"), fname, 2);
            return FALSE;
        }

        setMessageBoxInitialValue(messageBoxID, pcInitialValue, nbCol * nbRow);
        freeAllocatedMatrixOfString(nbRow, nbCol, pcInitialValue);
    }

    if (nbInputArgument(pvApiCtx) == 3)
    {
        if (checkInputArgumentType(pvApiCtx, 3, sci_boolean))
        {
            sciErr = getVarAddressFromPosition(pvApiCtx, 3, &piPasswordAddr);
            if (sciErr.iErr)
            {
                printError(&sciErr, 0);
                return FALSE;
            }

            if (getScalarBoolean(pvApiCtx, piPasswordAddr, &iPassword))
            {
                Scierror(999, _("%s: Wrong size for argument #%d: Scalar boolean expected.\n"), fname, 3);
                freeAllocatedMatrixOfString(nbRow, nbCol, pcTitle);
                return FALSE;
            }
        }
        else
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: Scalar boolean expected.\n"), fname, 3);
            return FALSE;
        }
    }

    /* Set password mode */
    setMessageBoxPasswordMode(messageBoxID, &iPassword, 1);

    /* Display it and wait for a user input */
    messageBoxDisplayAndWait(messageBoxID);

    /* Read the user answer */
    iUserValueSize = getMessageBoxValueSize(messageBoxID);
    if (iUserValueSize == 0)
    {
        nbRow = 0;
        nbCol = 0;

        sciErr = allocMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, nbRow, nbCol, &pdblEmptyMatrixAdr);
        if (sciErr.iErr)
        {
            printError(&sciErr, 0);
            Scierror(999, _("%s: Memory allocation error.\n"), fname);
            return 1;
        }
    }
    else
    {
        pcUserValue = getMessageBoxValue(messageBoxID);

        nbCol = 1;
        createMatrixOfString(pvApiCtx, nbInputArgument(pvApiCtx) + 1, iUserValueSize, nbCol, pcUserValue);
        delete[] pcUserValue;
    }

    AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
    ReturnArguments(pvApiCtx);
    return TRUE;
}
/*--------------------------------------------------------------------------*/
