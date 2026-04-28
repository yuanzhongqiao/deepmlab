/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
 */

#include "configvariable.hxx"
#include "core_gw.hxx"
#include "function.hxx"
#include "bool.hxx"
#include "string.hxx"
#include "context.hxx"

extern "C"
{
#include "Scierror.h"
#include "sciprint.h"
#include "localization.h"
}

/*
 * skipArguments() => enable arguments skipping
 * skipArguments("status") => get arguments skipping state (true/false)
 * 
 */
types::Function::ReturnValue sci_skipArguments(types::typed_list& in, int _iRetCount, types::typed_list& out)
{
    size_t rhs = in.size();
    if (rhs > 1)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d or %d expected.\n"), "skipArguments", 0, 1);
        return types::Function::Error;
    }

    if (rhs == 1)
    {
        if (in[0]->isString() == false || in[0]->getAs<types::String>()->isScalar() == false || wcscmp(in[0]->getAs<types::String>()->get()[0], L"status") != 0)
        {
            Scierror(999, _("%s: Wrong value for input argument #%d: \"%s\" excepted.\n"), "skipArguments", 1, "status");
            return types::Function::Error;
        }

        types::InternalType* pIT = symbol::Context::getInstance()->get(symbol::Symbol(L"%skipArgs"));
        if (pIT)
        {
            out.push_back(types::Bool::True());
        }
        else
        {
            out.push_back(types::Bool::False());
        }

        if (_iRetCount == 2)
        {
            if (pIT)
            {
                out.push_back(pIT);
            }
            else
            {
                out.push_back(types::Double::Empty());
            }
        }
        return types::Function::OK;
    }

    //rhs == 0
    std::wstring func;
    auto where = ConfigVariable::getWhere();
    if (where.size() > 1)
    {
        auto&& entry = *(++where.crbegin()); //get second-to-last block
        func = entry.call->getName();
    }
    else
    {
        func = L"console";
    }

    symbol::Context::getInstance()->put(symbol::Symbol(L"%skipArgs"), new types::String(func.c_str()));

    return types::Function::OK;
}
