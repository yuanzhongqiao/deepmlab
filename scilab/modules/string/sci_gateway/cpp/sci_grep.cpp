/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
*  Copyright (C) 2010 - DIGITEO - Antoine ELIAS
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

/* desc : search position of a character string in another string
using regular express .                                         */
/*------------------------------------------------------------------------*/

#include "string_gw.hxx"
#include "function.hxx"
#include "double.hxx"
#include "string.hxx"

extern "C"
{
#include "os_string.h"
#include "Scierror.h"
#include "localization.h"
#include "pcre2_private.h"
#include "sci_malloc.h" /* MALLOC */
#include "charEncoding.h"
}

/*------------------------------------------------------------------------*/
typedef struct grep_results
{
    int sizeArraysMax;
    int currentLength;
    int *values;
    int *positions;
} GREPRESULTS;
/*------------------------------------------------------------------------*/
static pcre2_error_code GREP_NEW(GREPRESULTS* results, wchar_t** Inputs_param_one, int mn_one, wchar_t** Inputs_param_two, int mn_two, wchar_t** formattedErrorMessage);
static pcre2_error_code GREP_OLD(GREPRESULTS* results, wchar_t** Inputs_param_one, int mn_one, wchar_t** Inputs_param_two, int mn_two);
/*------------------------------------------------------------------------*/
types::Function::ReturnValue sci_grep(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    bool bRegularExpression = false;

    //check input paramters
    if (in.size() < 2 || in.size() > 3)
    {
        Scierror(999, _("%s: Wrong number of input arguments: %d or %d expected.\n"), "grep", 2, 3);
        return types::Function::Error;
    }

    if (_iRetCount > 2)
    {
        Scierror(999, _("%s: Wrong number of output arguments: %d or %d expected.\n"), "grep", 1, 2);
        return types::Function::Error;
    }

    if (in[0]->isDouble() && in[0]->getAs<types::Double>()->getSize() == 0)
    {
        types::Double *pD = types::Double::Empty();
        out.push_back(pD);
        return types::Function::OK;
    }

    if (in.size() == 3)
    {
        //"r" for regular expression
        if (in[2]->isString() == false)
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: String expected.\n"), "grep", 3);
            return types::Function::Error;
        }

        types::String* pS = in[2]->getAs<types::String>();
        if (pS->getSize() != 1)
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: string expected.\n"), "grep", 3);
            return types::Function::Error;
        }

        if (pS->get(0)[0] == 'r')
        {
            bRegularExpression = true;
        }
    }

    if (in[0]->isString() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: String expected.\n"), "grep", 1);
        return types::Function::Error;
    }

    if (in[1]->isString() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: String expected.\n"), "grep", 2);
        return types::Function::Error;
    }

    types::String* pS1 = in[0]->getAs<types::String>();
    types::String* pS2 = in[1]->getAs<types::String>();


    for (int i = 0 ; i < pS2->getSize() ; i++)
    {
        if (wcslen(pS2->get(i)) == 0)
        {
            Scierror(249, _("%s: Wrong values for input argument #%d: Non-empty strings expected.\n"), "grep", 2);
            return types::Function::Error;
        }
    }

    GREPRESULTS grepresults;
    pcre2_error_code code_error_grep;

    grepresults.currentLength = 0;
    grepresults.sizeArraysMax = 0;
    grepresults.positions = NULL;
    grepresults.values = NULL;
    
    wchar_t* formattedErrorMessage = NULL;
    if (bRegularExpression)
    {
        code_error_grep = GREP_NEW(&grepresults, pS1->get(), pS1->getSize(), pS2->get(), pS2->getSize(), &formattedErrorMessage);
    }
    else
    {
        code_error_grep = GREP_OLD(&grepresults, pS1->get(), pS1->getSize(), pS2->get(), pS2->getSize());
    }

    types::Function::ReturnValue ret;
    if (code_error_grep == PCRE2_PRIV_FINISHED_OK || code_error_grep == PCRE2_PRIV_NO_MATCH)
    {
        ret = types::Function::OK;

        types::Double* pD1 = NULL;
        if (grepresults.currentLength == 0)
        {
            pD1 = types::Double::Empty();
        }
        else
        {
            pD1 = new types::Double(1, grepresults.currentLength);
            double* pDbl1 = pD1->getReal();
            for (int i = 0 ; i < grepresults.currentLength ; i++ )
            {
                pDbl1[i] = static_cast<double>(grepresults.values[i]);
            }
        }

        out.push_back(pD1);

        if (_iRetCount == 2)
        {
            types::Double* pD2 = NULL;
            if (grepresults.currentLength == 0)
            {
                pD2 = types::Double::Empty();
            }
            else
            {
                pD2 = new types::Double(1, grepresults.currentLength);
                double* pDbl2 = pD2->getReal();
                for (int i = 0 ; i < grepresults.currentLength ; i++ )
                {
                    pDbl2[i] = static_cast<double>(grepresults.positions[i]);
                }
            }

            out.push_back(pD2);
        }
    }
    else
    {
        ret = types::Function::Error;
        pcre2_error("grep", code_error_grep, formattedErrorMessage);
    }

    if (grepresults.values)
    {
        FREE(grepresults.values);
        grepresults.values = NULL;
    }
    if (grepresults.positions)
    {
        FREE(grepresults.positions);
        grepresults.positions = NULL;
    }

    return ret;
}
/*-----------------------------------------------------------------------------------*/
static pcre2_error_code GREP_NEW(GREPRESULTS* results, wchar_t** Inputs_param_one, int mn_one, wchar_t** Inputs_param_two, int mn_two, wchar_t** formattedErrorMessage)
{
    int x = 0, y = 0;
    wchar_t* save = NULL;
    pcre2_error_code iRet = PCRE2_PRIV_FINISHED_OK;
    results->sizeArraysMax = mn_one * mn_two;

    results->values = (int *)MALLOC(sizeof(int) * results->sizeArraysMax);
    results->positions = (int *)MALLOC(sizeof(int) * results->sizeArraysMax);

    if ( (results->values == NULL) || (results->positions == NULL) )
    {
        if (results->values)
        {
            FREE(results->values);
            results->values = NULL;
        }
        if (results->positions)
        {
            FREE(results->positions);
            results->positions = NULL;
        }
        return PCRE2_PRIV_NOT_ENOUGH_MEMORY_FOR_VECTOR;
    }

    results->currentLength = 0;
    for ( y = 0; y < mn_one; ++y)
    {
        for ( x = 0; x < mn_two; ++x)
        {
            int Output_Start = 0;
            int Output_End = 0;
            save = os_wcsdup(Inputs_param_two[x]);
            pcre2_error_code answer = pcre2_private(Inputs_param_one[y], save, &Output_Start, &Output_End, NULL, NULL, formattedErrorMessage);

            if (save)
            {
                FREE(save);
                save = NULL;
            }

            if (answer == PCRE2_PRIV_FINISHED_OK)
            {
                results->values[results->currentLength] = y + 1;
                results->positions[results->currentLength] = x + 1;
                results->currentLength++;
            }
            else if (answer != PCRE2_PRIV_NO_MATCH)
            {
                // stop on first error and report the error code and message
                iRet = answer;
                break;
            }
        }
    }

    return iRet;
}
/*-----------------------------------------------------------------------------------*/
static pcre2_error_code GREP_OLD(GREPRESULTS *results, wchar_t** Inputs_param_one, int mn_one, wchar_t** Inputs_param_two, int mn_two)
{
    int x = 0, y = 0;

    results->values = (int *)MALLOC(sizeof(int) * (mn_one * mn_two + 1));
    results->positions = (int *)MALLOC(sizeof(int) * (mn_one * mn_two + 1));

    for (y = 0; y < mn_one; ++y)
    {
        for (x = 0; x < mn_two; ++x)
        {
            wchar_t* wcInputOne = Inputs_param_one[y];
            wchar_t* wcInputTwo = Inputs_param_two[x];

            if (wcInputOne && wcInputTwo)
            {
                if (wcsstr(wcInputOne, wcInputTwo) != NULL)
                {
                    results->values[results->currentLength] = y + 1;
                    results->positions[results->currentLength] = x + 1;
                    results->currentLength++;
                }
            }
        }
    }
    return PCRE2_PRIV_FINISHED_OK;
}
/*-----------------------------------------------------------------------------------*/
