/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2010 - 2012 - INRIA - Allan CORNET
 * Copyright (C) 2011 - INRIA - Michael Baudin
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
 * This code is also published under the GPL v3 license.
 *
 */
#include <string.h>
#include <wchar.h>

#include "Scierror.h"
#include "api_scilab.h"
#include "csvDefault.h"
#include "csvRead.h"
#include "freeArrayOfString.h"
#include "getRange.h"
#include "gw_csv_helpers.h"
#include "gw_spreadsheet.h"
#include "localization.h"
#include "charEncoding.h"
#include "os_string.h"
#include "sci_malloc.h"
#include "splitLine.h"
#include "stringToComplex.h"

static void freeVar(wchar_t*** text, int sizeText, int** lengthText, wchar_t** separator, wchar_t** decimal, wchar_t** conversion, int** iRange, wchar_t*** toreplace, int sizeReplace);
// =============================================================================
#define CONVTOSTR L"string"
#define CONVTODOUBLE L"double"
// =============================================================================
int sci_csvTextScan(char* fname, void* pvApiCtx)
{
    SciErr sciErr;
    int iErr = 0;

    int m1 = 0, n1 = 0;

    wchar_t** text = NULL;
    int* lengthText = NULL;
    int nbLines = 0;

    wchar_t* separator = NULL;
    wchar_t* decimal = NULL;
    wchar_t* conversion = NULL;

    int* iRange = NULL;
    int haveRange = 0;

    wchar_t **toreplace = NULL;
    int nbElementsToReplace = 0;

    wchar_t** pstrValues = NULL;
    double* pDblRealValues = NULL;
    double* pDblImgValues = NULL;
    char* errorMsg = NULL;

    CheckRhs(1, 6);
    CheckLhs(0, 1);

    if (Rhs == 6)
    {
        int m6 = 0, n6 = 0;
        toreplace = csv_getArgumentAsMatrixOfWideString(pvApiCtx, 6, fname, &m6, &n6, &iErr);
        if (iErr)
        {
            freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
            return 0;
        }

        if (n6 != 2)
        {
            freeVar(&text, nbLines, &lengthText,  &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
            Scierror(999, _("%s: Wrong size for input argument #%d.\n"), fname, 6);
            return 0;
        }
        nbElementsToReplace = m6;
    }

    if (Rhs >= 5)
    {
        int m5 = 0, n5 = 0;
        int* piAddressVar = NULL;
        int iType = 0;

        sciErr = getVarAddressFromPosition(pvApiCtx, 5, &piAddressVar);
        if (sciErr.iErr)
        {
            printError(&sciErr, 0);
            return 0;
        }

        sciErr = getVarType(pvApiCtx, piAddressVar, &iType);
        if (sciErr.iErr)
        {
            printError(&sciErr, 0);
            return 0;
        }

        switch (iType)
        {
            case sci_matrix :
                // range - double vector
                iRange = csv_getArgumentAsMatrixofIntFromDouble(pvApiCtx, 5, fname, &m5, &n5, &iErr);
                if (iErr)
                {
                    freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
                    return 0;
                }

                if ((m5 * n5 != SIZE_RANGE_SUPPORTED))
                {
                    freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
                    Scierror(999, _("%s: Wrong size for input argument #%d: Four entries expected.\n"), fname, 5);
                    return 0;
                }

                if ((m5 != 1) && (n5 != 1))
                {
                    freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
                    Scierror(999, _("%s: Wrong size for input argument #%d: A column or row vector expected.\n"), fname, 5);
                    return 0;
                }

                if (isValidRange(iRange, m5 * n5))
                {
                    haveRange = 1;
                }
                else
                {
                    freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
                    Scierror(999, _("%s: Wrong value for input argument #%d: Inconsistent range.\n"), fname, 5);
                    return 0;
                }
                break;
                
            case sci_strings :
                // substitute 
                toreplace = csv_getArgumentAsMatrixOfWideString(pvApiCtx, 5, fname, &m5, &n5, &iErr);
                if (iErr)
                {
                    freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
                    return 0;
                }

                if (n5 != 2)
                {
                    freeVar(&text, nbLines, &lengthText,  &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
                    Scierror(999, _("%s: Wrong size for input argument #%d.\n"), fname, 5);
                    return 0;
                }
                nbElementsToReplace = m5;
                break;

            default :
                freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
                Scierror(999, _("%s: Wrong type for input argument #%d: A double or string expected.\n"), fname, 5);
                return 0;
        }
    }

    if (Rhs >= 4)
    {
        conversion = csv_getArgumentAsWideStringWithEmptyManagement(pvApiCtx, 4, fname, getCsvDefaultConversion(), &iErr);
        if (iErr)
        {
            freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
            return 0;
        }

        if (!((wcscmp(conversion, CONVTOSTR) == 0) || (wcscmp(conversion, CONVTODOUBLE) == 0)))
        {
            freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
            Scierror(999, _("%s: Wrong value for input argument #%d: '%s' or '%s' string expected.\n"), fname, 4, "double", "string");
            return 0;
        }
    }
    else
    {
        conversion = to_wide_string(getCsvDefaultConversion());
    }

    if (Rhs >= 3)
    {
        decimal = csv_getArgumentAsWideStringWithEmptyManagement(pvApiCtx, 3, fname, getCsvDefaultDecimal(), &iErr);
        if (iErr)
        {
            freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
            return 0;
        }

        if (decimal[0] != '.' && decimal[0] != ',')
        {
            freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
            Scierror(999, _("%s: Wrong value for input argument #%d: '%s' or '%s' string expected.\n"), fname, 3, ",", ".");
            return 0;
        }
    }
    else
    {
        decimal = to_wide_string(getCsvDefaultDecimal());
    }

    if (Rhs >= 2)
    {
        separator = csv_getArgumentAsWideStringWithEmptyManagement(pvApiCtx, 2, fname, getCsvDefaultSeparator(), &iErr);
        if (iErr)
        {
            freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
            return 0;
        }
    }
    else
    {
        separator = to_wide_string(getCsvDefaultSeparator());
    }

    if (!csv_isRowVector(pvApiCtx, 1) &&
            !csv_isColumnVector(pvApiCtx, 1) &&
            !csv_isScalar(pvApiCtx, 1))
    {
        freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
        Scierror(999, _("%s: Wrong size for input argument #%d: String vector expected.\n"), fname, 1);
        return 0;
    }

    text = csv_getArgumentAsMatrixOfWideString(pvApiCtx, 1, fname, &m1, &n1, &iErr);
    nbLines = m1 * n1;
    if (iErr)
    {
        freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
        return 0;
    }

    /*
     * Preconditions
     */

    // decimal and separator should be different
    if (wcscmp(separator, decimal) == 0)
    {
        freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
        Scierror(999, _("%s: separator and decimal must have different values.\n"), fname);
        return 0;
    }

    // validate size
    errorMsg = csvTextScanSize(text, &nbLines, separator, &m1, &n1, haveRange, iRange);
    if (errorMsg != NULL)
    {
        freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
        Scierror(999, errorMsg, fname);
        return 0;
    }


    /*
     * Allocate some memory to store the decoded content
     */

    if (wcscmp(conversion, CONVTOSTR) == 0)
    {
        // allocMatrixOfWideString (non existing yet) here will avoid an extra copy
        if (haveRange)
        {
            pstrValues = CALLOC((iRange[2] - iRange[0] + 1) * (iRange[3] - iRange[1] + 1), sizeof(wchar_t*));
        }
        else
        {
            pstrValues = CALLOC(m1 * n1, sizeof(wchar_t*));
        }
    }
    else
    {
        if (haveRange)
        {
            sciErr = allocMatrixOfDouble(pvApiCtx, Rhs + 1, (iRange[2] - iRange[0] + 1), (iRange[3] - iRange[1] + 1), &pDblRealValues);
        }
        else
        {
            sciErr = allocMatrixOfDouble(pvApiCtx, Rhs + 1, m1, n1, &pDblRealValues);
        }
        if (sciErr.iErr)
        {
            printError(&sciErr, 0);
            Scierror(17, _("%s: Memory allocation error.\n"), fname);
            freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
            return 0;
        }
    }

    if (toreplace && (nbElementsToReplace > 0))
    {
        // use substitute 
        replaceStrings(text, &nbLines, toreplace, nbElementsToReplace * 2);
    }

    /*
     * Decode each cell into the previously allocated memory, this code should not allocate per-cell
     * but rather manipulate the input lines to speed the decoding.
     *
     * Note: some global allocation are also performed depending in some parsing condition. For example,
     * the image buffer of complex numbers is allocated only when a complex number is detected.
     */
    if (csvTextScanInPlace(text, nbLines, separator, decimal, haveRange, iRange, m1, n1, pstrValues, pDblRealValues, &pDblImgValues))
    {
        Scierror(17, _("%s: Memory allocation error.\n"), fname);
        freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
        return 0;
    }

    // push or recreate Scilab variables
    if (pDblRealValues != NULL && pDblImgValues != NULL)
    {
        // assign the re-allocated complex array
        if (haveRange)
        {
            sciErr = createComplexMatrixOfDouble(pvApiCtx, Rhs + 2, (iRange[2] - iRange[0] + 1), (iRange[3] - iRange[1] + 1), pDblRealValues, pDblImgValues);
        }
        else
        {
            sciErr = createComplexMatrixOfDouble(pvApiCtx, Rhs + 2, m1, n1, pDblRealValues, pDblImgValues);
        }
        if (sciErr.iErr)
        {
            printError(&sciErr, 0);
            Scierror(17, _("%s: Memory allocation error.\n"), fname);
            freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
            FREE(pDblImgValues);
            return 0;
        }
        FREE(pDblImgValues);
        LhsVar(1) = Rhs + 2;
    }
    else if (pDblRealValues != NULL)
    {
        // data have been copied in place, just assign !
        LhsVar(1) = Rhs + 1;
    }
    else
    {
        // string conversion, copy the data back to Scilab
        if (haveRange)
        {
            sciErr = createMatrixOfWideString(pvApiCtx, Rhs + 1, (iRange[2] - iRange[0] + 1), (iRange[3] - iRange[1] + 1), pstrValues);
        }
        else
        {
            sciErr = createMatrixOfWideString(pvApiCtx, Rhs + 1, m1, n1, pstrValues);
        }
        if (sciErr.iErr)
        {
            printError(&sciErr, 0);
            Scierror(17, _("%s: Memory allocation error.\n"), fname);
            freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
            return 0;
        }
        LhsVar(1) = Rhs + 1;

        FREE(pstrValues);
    }

    freeVar(&text, nbLines, &lengthText, &separator, &decimal, &conversion, &iRange, &toreplace, nbElementsToReplace * 2);
    return 0;
}
// =============================================================================
static void freeVar(wchar_t*** text, int sizeText, int** lengthText, wchar_t** separator, wchar_t** decimal, wchar_t** conversion, int** iRange, wchar_t*** toreplace, int sizeReplace)
{
    if (text && *text)
    {
        freeArrayOfWideString(*text, sizeText);
        *text = NULL;
    }

    if (lengthText && *lengthText)
    {
        FREE(*lengthText);
        *lengthText = NULL;
    }

    if (separator && *separator)
    {
        FREE(*separator);
        *separator = NULL;
    }

    if (decimal && *decimal)
    {
        FREE(*decimal);
        *decimal = NULL;
    }

    if (conversion && *conversion)
    {
        FREE(*conversion);
        *conversion = NULL;
    }

    if (iRange && *iRange)
    {
        FREE(*iRange);
        *iRange = NULL;
    }

    if (toreplace && *toreplace)
    {
        freeArrayOfWideString(*toreplace, sizeReplace);
        *toreplace = NULL;
    }
}
