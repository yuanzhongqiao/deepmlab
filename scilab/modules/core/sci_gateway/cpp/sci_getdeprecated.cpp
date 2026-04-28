/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2024 - Dassault Systèmes S.E. - Cédric DELAMARRE
 */

#include "core_gw.hxx"
#include "getdeprecated.hxx"
#include "string.hxx"
#include "function.hxx"

extern "C"
{
#include "localization.h"
#include "Scierror.h"
}

static std::string fname = "getdeprecated";
types::Function::ReturnValue sci_getdeprecated(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    if (_iRetCount > 2)
    {
        Scierror(78, _("%s: Wrong number of output argument(s): %d or %d expected.\n"), fname.c_str(), 1, 2);
        return types::Function::Error;
    }

    if (in.size() != 0)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d expected.\n"), fname.c_str(), 0);
        return types::Function::Error;
    }

    std::unordered_map<std::wstring, std::wstring> mDeprecated = getDeprecated();

    types::String *pDeprecated = new types::String(mDeprecated.size(), 1);
    int iter = 0;
    for(const auto& d : mDeprecated)
    {
        pDeprecated->set(iter++, d.first.data());
    }
    out.push_back(pDeprecated);

    if(_iRetCount == 2)
    {
        types::String *pReplacedBy = new types::String(mDeprecated.size(), 1);
        int iter = 0;
        for(const auto& d : mDeprecated)
        {
            pReplacedBy->set(iter++, d.second.data());
        }
        out.push_back(pReplacedBy);
    }

    return types::Function::OK;
}
