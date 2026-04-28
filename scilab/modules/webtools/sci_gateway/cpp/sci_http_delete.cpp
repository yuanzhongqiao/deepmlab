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

extern "C"
{
#include "localization.h"
#include "Scierror.h"
#include "sciprint.h"
#include "sci_malloc.h"
}
/*--------------------------------------------------------------------------*/
static const char fname[] = "http_delete";
types::Function::ReturnValue sci_http_delete(types::typed_list &in, types::optional_list &opt, int _iRetCount, types::typed_list &out)
{
    if (in.size() != 1)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d expected.\n"), fname, 1);
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

    query.setMethod("DELETE");

    // common optional argument
    if(checkCommonOpt(query, opt, fname))
    {
        return types::Function::Error;
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
