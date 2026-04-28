/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include "function.hxx"
#include "double.hxx"
#include "string.hxx"
#include "int.hxx"
#include "url_tools.hxx"
#include "webtools_gw.hxx"

extern "C"
{
#include "Scierror.h"
#include "localization.h"
}

static const char fname[] = "url_split";
types::Function::ReturnValue sci_url_split(types::typed_list& in, int _iRetCount, types::typed_list& out)
{
    if (in.size() != 1)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d expected.\n"), fname, 1);
        return types::Function::Error;
    }

    if (_iRetCount > 7)
    {
        Scierror(78, _("%s: Wrong number of output argument(s): %d expected.\n"), fname, 7);
        return types::Function::Error;
    }

    // []
    if (in[0]->isDouble() && in[0]->getAs<types::Double>()->isEmpty())
    {
        out.push_back(in[0]);
        return types::Function::OK;
    }

    // get URL
    if (in[0]->isString() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: Matrix of strings expected.\n"), fname, 1);
        return types::Function::Error;
    }

    types::String* pIn = in[0]->getAs<types::String>();
    char* c = wide_string_to_UTF8(pIn->get()[0]);
    std::string s(c);
    std::string scheme, server, path, query, user, password, port, fragment;
    int ret = url_split(s, scheme, server, path, query, user, password, port, fragment);
    FREE(c);

    if (ret != 0)
    {
        Scierror(999, _("%s: Could not parse the URL.\n"), fname);
        return types::Function::Error;
    }

    std::string userpass = user + (password != "" ? (":" + password) : "");

    // create output
    out.push_back(new types::String(scheme.data()));
    out.push_back(new types::String(server.data()));
    out.push_back(new types::String(path.data()));
    out.push_back(new types::String(query.data()));
    out.push_back(new types::String(userpass.data()));
    out.push_back(new types::Int32(atoi(port.data())));
    out.push_back(new types::String(fragment.data()));
    return types::Function::OK;
}
