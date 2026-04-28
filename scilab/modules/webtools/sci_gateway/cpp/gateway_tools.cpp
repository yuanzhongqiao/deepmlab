/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
* Copyright (C) 2017 - ESI-Group - Cedric DELAMARRE
*
* This file is hereby licensed under the terms of the GNU GPL v2.0,
* pursuant to article 5.3.4 of the CeCILL v.2.1.
* This file was originally licensed under the terms of the CeCILL v2.1,
* and continues to be available under such terms.
* For more information, see the COPYING file which you should have received
* along with this program.
*
*/
/*--------------------------------------------------------------------------*/

#include "gateway_tools.hxx"
#include "function.hxx"
#include "string.hxx"
#include "double.hxx"

extern "C"
{
#include "localization.h"
#include "Scierror.h"
#include "sci_malloc.h"
}

int setPreferences(SciCurl& query, const char* fname)
{
    // set proxy information
    if(query.setProxy() == false)
    {
        Scierror(999, _("%s: Wrong proxy information, please check in the '%s' Scilab preference.\n"), fname, _("Web"));
        return 1;
    }    

    // set cookies information
    if(query.setCookies() == false)
    {
        Scierror(999, _("%s: Wrong cookies information, please check in the '%s' Scilab preference.\n"), fname, _("Web"));
        return 1;
    }

    return 0;
}

int checkCommonOpt(SciCurl& query, types::optional_list& opt, const char* fname)
{
    // get optional argument if necessary
    for (const auto& o : opt)
    {
        if (o.first == L"cert")
        {
            if(o.second->isString() == false || o.second->getAs<types::String>()->isScalar() == false)
            {
                Scierror(999, _("%s: Wrong type for input argument #%s: A scalar string expected.\n"), fname, "cert");
                return 1;
            }

            wchar_t* pCert = o.second->getAs<types::String>()->get(0);
            if(wcscmp(pCert, L"none") == 0)
            {
                query.ssl(false);
                continue;
            }
            // TODO management of cert file
            // else if cert is file

            Scierror(999, _("%s: Wrong value for input argument #%s: 'none' expected.\n"), fname, "cert");
            return 1;
        }
        else if(o.first == L"follow")
        {
            if(o.second->isBool() == false || o.second->getAs<types::Bool>()->isScalar() == false)
            {
                Scierror(999, _("%s: Wrong type for input argument #%s: A scalar boolean expected.\n"), fname, "follow");
                return 1;
            }

            if(o.second->getAs<types::Bool>()->get(0) == 1)
            {
                query.follow(1);
            }
        }
        else if(o.first == L"auth")
        {
            if(o.second->isString() == false || o.second->getAs<types::String>()->isScalar() == false)
            {
                Scierror(999, _("%s: Wrong type for input argument #%s: A scalar string expected.\n"), fname, "auth");
                return 1;
            }

            char* pAuth = wide_string_to_UTF8(o.second->getAs<types::String>()->get(0));
            query.auth(pAuth);
            FREE(pAuth);
        }
        else if(o.first == L"verbose")
        {
            if(o.second->isBool() == false || o.second->getAs<types::Bool>()->isScalar() == false)
            {
                Scierror(999, _("%s: Wrong type for input argument #%s: A scalar boolean expected.\n"), fname, "verbose");
                return 1;
            }

            if(o.second->getAs<types::Bool>()->get(0) == 1)
            {
                query.verbose(true, fname);
            }
        }
        else if(o.first == L"headers")
        {
            if(o.second->isString() == false)
            {
                Scierror(999, _("%s: Wrong type for input argument #%s: String expected.\n"), fname, "headers");
                return 1;
            }

            types::String* pStr = o.second->getAs<types::String>();
            for(int i = 0; i < pStr->getSize(); ++i)
            {
                char* pcHeader = wide_string_to_UTF8(pStr->get(i));
                query.addHTTPHeader(pcHeader);
                FREE(pcHeader);
            }
        }
        else if(o.first == L"cookies")
        {
            if(o.second->isString() == false)
            {
                Scierror(999, _("%s: Wrong type for input argument #%s: String expected.\n"), fname, "cookies");
                return 1;
            }

            types::String* pStr = o.second->getAs<types::String>();
            std::stringstream cookies;
            for(int i = 0; i < pStr->getSize(); ++i)
            {
                char* pcCookies = wide_string_to_UTF8(pStr->get(i));
                cookies << pcCookies << ";";
                FREE(pcCookies);
            }

            query.setCustomCookies(cookies.str().data());
        }
        else if(o.first == L"timeout")
        {
            if(o.second->isDouble() == false)
            {
                Scierror(999, _("%s: Wrong type for input argument #%s: Constant expected.\n"), fname, "timeout");
                return 1;
            }

            types::Double* pDbl = o.second->getAs<types::Double>();
            if(pDbl->isScalar() == false)
            {
                Scierror(999, _("%s: Wrong size for input argument #%s: Scalar expected.\n"), fname, "timeout");
                return 1;
            }

            int iErr = query.setTimeOut(pDbl->get(0));
            if(iErr)
            {
                Scierror(999, _("%s: Wrong value for input argument #%s: Positive value expected.\n"), fname, "timeout");
                return 1;
            }
        }
    }

    return 0;
}
