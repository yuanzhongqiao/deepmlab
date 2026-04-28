/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
* Copyright (C) 2013 - Scilab Enterprises - Cedric Delamarre
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

#include "string_gw.hxx"
#include "function.hxx"
#include "string.hxx"
#include "double.hxx"
#include "bool.hxx"
#include "overload.hxx"

extern "C"
{
#include "sci_malloc.h"
#include "Scierror.h"
#include "localization.h"
#include "strsplit.h"
#include "pcre2_private.h"
#include "freeArrayOfString.h"
}

static int strsplit_delimiter(wchar_t* in, types::String* pStrOut, wchar_t* delimiter, int limit);

types::Function::ReturnValue sci_strsplit(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    types::String* pStrIn = NULL;
    int iValueThree = 0;

    if (in.size() < 1 || in.size() > 3)
    {
        Scierror(999, _("%s: Wrong number of input arguments: %d to %d expected.\n"), "strsplit", 1, 3);
        return types::Function::Error;
    }

    if (_iRetCount > 2)
    {
        Scierror(999, _("%s: Wrong number of output arguments: %d to %d expected.\n"), "strsplit", 1, 2);
        return types::Function::Error;
    }

    // [[], ""] = strsplit([],...)
    if (in[0]->isDouble() && in[0]->getAs<types::Double>()->isEmpty())
    {
        out.push_back(types::Double::Empty());

        if (_iRetCount == 2)
        {
            out.push_back(new types::String(L""));
        }

        return types::Function::OK;
    }

    if (in[0]->isString() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: string expected.\n"), "strsplit", 1);
        return types::Function::Error;
    }

    pStrIn = in[0]->getAs<types::String>();

    if (pStrIn->isScalar() == false)
    {
        Scierror(999, _("%s: Wrong size for input argument #%d: A single string expected.\n"), "strsplit", 1);
        return types::Function::Error;
    }

    if (in.size() > 2)
    {
        if (in[2]->isDouble() == false)
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: A double expected.\n"), "strsplit", 3);
            return types::Function::Error;
        }

        types::Double* pDblIn = in[2]->getAs<types::Double>();

        if (pDblIn->isScalar() == false)
        {
            Scierror(999, _("%s: Wrong size for input argument #%d: A scalar double expected.\n"), "strsplit", 3);
            return types::Function::Error;
        }

        iValueThree = (int)pDblIn->get(0);

        if ( (double)iValueThree != pDblIn->get(0))
        {
            Scierror(999, _("%s: Wrong value for input argument #%d: An integer value expected.\n"), "strsplit", 3);
            return types::Function::Error;
        }

        if ((iValueThree < 1) && (iValueThree != -1))
        {
            Scierror(999, _("%s: Wrong size for input argument #%d: A positive value expected.\n"), "strsplit", 3);
            return types::Function::Error;
        }
    }

    if (in.size() > 1)
    {
        if (in[1]->isDouble())
        {
            types::Double* pDbl = in[1]->getAs<types::Double>();

            if (_iRetCount == 2)
            {
                Scierror(999, _("%s: Wrong number of output arguments: %d expected.\n"), "strsplit", 1);
                return types::Function::Error;
            }

            if (pDbl->getRows() != 1 && pDbl->getCols() != 1)
            {
                Scierror(999, _("%s: Wrong size for input argument #%d: A Scalar or vector expected.\n"), "strsplit", 2);
                return types::Function::Error;
            }

            strsplit_error ierr = STRSPLIT_NO_ERROR;
            wchar_t **results = strsplit(pStrIn->get(0), pDbl->get(), pDbl->getSize(), &ierr);

            switch (ierr)
            {
                case STRSPLIT_NO_ERROR:
                {
                    types::String* pStrOut = new types::String(pDbl->getSize() + 1, 1);
                    pStrOut->set(results);

                    freeArrayOfWideString(results, pDbl->getSize() + 1);
                    out.push_back(pStrOut);
                    return types::Function::OK;
                }
                break;
                case STRSPLIT_INCORRECT_VALUE_ERROR:
                {
                    freeArrayOfWideString(results, pDbl->getSize() + 1);
                    Scierror(999, _("%s: Wrong value for input argument #%d.\n"), "strsplit", 2);
                    return types::Function::Error;
                }
                break;
                case STRSPLIT_INCORRECT_ORDER_ERROR:
                {
                    freeArrayOfWideString(results, pDbl->getSize() + 1);
                    Scierror(999, _("%s: Elements of %dth argument must be in increasing order.\n"), "strsplit", 2);
                    return types::Function::Error;
                }
                break;
                case STRSPLIT_MEMORY_ALLOCATION_ERROR:
                {
                    freeArrayOfWideString(results, pDbl->getSize() + 1);
                    Scierror(999, _("%s: Memory allocation error.\n"), "strsplit");
                    return types::Function::Error;
                }
                break;
                default:
                {
                    freeArrayOfWideString(results, pDbl->getSize() + 1);
                    Scierror(999, _("%s: error.\n"), "strsplit");
                    return types::Function::Error;
                }
                break;
            }
        }
        else if (in[1]->isString())
        {
            types::String* pStr = in[1]->getAs<types::String>();
            if (pStr->isScalar() && pcre2_split_pattern(*pStr->get(), nullptr, nullptr, nullptr) == nullptr)
            {
                // a string delimiter to split on
                types::String* pStrOut = new types::String(1, 1);
                int i = strsplit_delimiter(pStrIn->get(0), pStrOut, pStr->get(0), iValueThree);
                
                out.push_back(pStrOut);
                if (_iRetCount > 1)
                {
                    if (i == 0)
                    {
                        out.push_back(types::Double::Empty());
                    }
                    else
                    {
                        types::String* pMatch = new types::String(i, 1);
                        while(i > 0)
                        {
                            pMatch->set(--i, pStr->get(0));
                        }
                        out.push_back(pMatch);
                    }
                }
                return types::Function::OK;
            }
            else if (!pStr->isScalar())
            {
                // checks that 2nd parameter is not an array of regexp pattern
                wchar_t** pwcsStr = pStr->get();
                for (int i = 0; i < pStr->getSize(); i++)
                {
                    if (pwcsStr[i] && pcre2_split_pattern(pwcsStr[i], nullptr, nullptr, nullptr) != nullptr)
                    {
                        Scierror(999, _("%s: Wrong value for input argument #%d: strings expected, not a regexp pattern.\n"), "strsplit", 2);
                        return types::Function::Error;
                    }
                }
            }
        }
        else
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: A double or string expected.\n"), "strsplit", 2);
            return types::Function::Error;
        }
    }

    return Overload::call(L"%_strsplit", in, _iRetCount, out);
}
/*-------------------------------------------------------------------------------------*/
int strsplit_delimiter(wchar_t* in, types::String* pStrOut, wchar_t* delimiter, int limit)
{
    wchar_t* remaining =  in;
    size_t delimiter_len = wcslen(delimiter);

    int i = 0;

    if (limit < 1)
    {
        limit = INT_MAX;
    }

    auto next_delimiter = [delimiter_len](wchar_t* str, wchar_t* delimiter) -> wchar_t*
    {
        // empty delimiter case : split on every character
        if (delimiter_len == 0)
        {    
            // ensure we are not at the end
            if (*str == L'\0')
            {
                return nullptr;
            }
            return str + 1;
        }
        // common delimiter case : split on a string
        return wcsstr(str, delimiter);
    };

    // assign all parts till limit
    wchar_t* next;
    wchar_t* last_delimiter = nullptr;
    while((next = next_delimiter(remaining, delimiter)) != nullptr && i < limit)
    {
        // reserve place for the part
        pStrOut->resize(i+1, 1);

        // assign in-place (swap delimiter with end-of-line)
        wchar_t pre = *next;
        *next = L'\0';
        pStrOut->set(i, remaining);
        *next = pre;

        // iterate
        last_delimiter = next;
        remaining = next + delimiter_len;
        i++;
    }

    // special case of empty delimiter and empty input string
    if (i == 0 && delimiter_len == 0)
    {
        pStrOut->set(0, L"");
        return 1;
    }

    // push the remaining:
    //  * no delimiter found, the whole string is stored
    //  * the limit is reached, there might be trailing content
    //  * last delimiter is at the end of the input string, an empty string is added
    if (i == 0 || i == limit || (delimiter_len > 0 && remaining == last_delimiter + delimiter_len))
    {
        pStrOut->resize(i+1, 1);
        pStrOut->set(i, remaining);
    }
    return i;
}
/*-------------------------------------------------------------------------------------*/
