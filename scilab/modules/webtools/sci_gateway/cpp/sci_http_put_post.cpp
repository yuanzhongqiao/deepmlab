/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
* Copyright (C) 2017 - ESI-Group - Cedric DELAMARRE
*
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
#include "webtools_gw.hxx"
#include "function.hxx"
#include "string.hxx"
#include "double.hxx"
#include "UTF8.hxx"
#include "json.hxx"

extern "C"
{
#include "localization.h"
#include "Scierror.h"
#include "sciprint.h"
#include "sci_malloc.h"
}

/*--------------------------------------------------------------------------*/
types::Function::ReturnValue sci_http_put_post(types::typed_list &in, types::optional_list &opt, int _iRetCount, types::typed_list &out, const char* fname)
{
    bool isJson  = false;

    if (in.size() < 1 || in.size() > 2)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d to %d expected.\n"), fname, 1, 2);
        return types::Function::Error;
    }

    if (_iRetCount > 3)
    {
        Scierror(78, _("%s: Wrong number of output argument(s): %d to %d expected.\n"), fname, 1, 3);
        return types::Function::Error;
    }

    // get URL
    if(in[0]->isString() == false || in[0]->getAs<types::String>()->isScalar() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: A scalar string expected.\n"), fname, 1);
        return types::Function::Error;
    }

    SciCurl query;
    if(query.init() == false)
    {
        Scierror(999, _("%s: CURL initialization failed.\n"), fname);
        return types::Function::Error;
    }

    if(setPreferences(query, fname))
    {
        return types::Function::Error;
    }

    char* pcURL = wide_string_to_UTF8(in[0]->getAs<types::String>()->get(0));
    query.setURL(pcURL);
    FREE(pcURL);

    if(strcmp(fname, "http_put") == 0)
    {
        query.setMethod("PUT");
    }
    else if(strcmp(fname, "http_post") == 0)
    {
        query.setMethod("POST");
    }
    else
    {
        query.setMethod("PATCH");
    }

    // common optional argument
    if(checkCommonOpt(query, opt, fname))
    {
        return types::Function::Error;
    }

    // specific optional argument
    for (const auto& o : opt)
    {
        if(o.first == L"format")
        {
            if(o.second->isString() == false || o.second->getAs<types::String>()->isScalar() == false)
            {
                Scierror(999, _("%s: Wrong type for input argument #%s: A scalar string expected.\n"), fname, "format");
                return types::Function::Error;
            }

            if( (wcscmp(o.second->getAs<types::String>()->get(0), L"JSON") == 0) ||
                (wcscmp(o.second->getAs<types::String>()->get(0), L"json") == 0))
            {
                isJson = true;
            }
        }
    }

    std::string data;
    if(in.size() > 1)
    {
        // get data
        if(in[1]->isString() && in[1]->getAs<types::String>()->isScalar())
        {
            data = scilab::UTF8::toUTF8(in[1]->getAs<types::String>()->get(0));
        }
        else
        {
            std::string err;
            data = toJSON(in[1], err);
            if(err.empty() == false)
            {
                Scierror(999, _("%s: JSON convertion failed.\n%s\n"), fname, err.c_str());
                return types::Function::Error;
            }

            isJson = true;
        }

        if(isJson)
        {
            query.addHTTPHeader("Accept: application/json");
            query.addHTTPHeader("Content-Type: application/json;charset=utf-8");
        }

        query.setData(data.c_str());
    }

    // configure headers when they have all been added.
    query.setHTTPHeader();

    // send the query
    query.perform();
    if(query.hasFailed())
    {
        Scierror(999, _("%s: CURL execution failed.\n%s\n"), fname, query.getError());
        return types::Function::Error;
    }

    out.push_back(query.getResult());
    if(_iRetCount > 1)
    {
        out.push_back(new types::Double((double)query.getResponseCode()));
    }

    if(_iRetCount > 2)
    {
        out.push_back(query.getHeaders());
    }

    return types::Function::OK;
}
