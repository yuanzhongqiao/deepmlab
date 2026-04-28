/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 */

#include "core_gw.hxx"
#include "context.hxx"
#include "function.hxx"
#include "string.hxx"
#include "classdef.hxx"
#include "object.hxx"

extern "C"
{
#include "sciprint.h"
#include "Scierror.h"
#include "charEncoding.h"
#include "localization.h"
}

types::Function::ReturnValue sci_properties(types::typed_list& in, int _iRetCount, types::typed_list& out)
{
    if (in.size() != 1)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d expected.\n"), "properties", 1);
        return types::Function::Error;
    }

    types::InternalType* pIT = in[0];

    if (pIT->isString() == false && pIT->isClassdef() == false && pIT->isObject() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: %s, %s or %s expected.\n"), "properties", 1, "string", "classname", "object");
        return types::Function::Error;
    }

    types::Classdef* def = nullptr;
    if (pIT->isString())
    {
        pIT = symbol::Context::getInstance()->get(symbol::Symbol(pIT->getAs<types::String>()->get(0)));
        if (pIT->isClassdef() == false)
        {
            Scierror(999, _("%s: Wrong value for input argument #%d: \"%s\" expected.\n"), "properties", 2, "classname");
            return types::Function::Error;
        }

        def = pIT->getAs<types::Classdef>();
    }

    if (pIT->isObject())
    {
        def = pIT->getAs<types::Object>()->getClassdef();
    }

    if (pIT->isClassdef())
    {
        def = pIT->getAs<types::Classdef>();
    }

    if (def != nullptr)
    {
        std::vector<std::wstring> props = def-> getPublicProperties();
        if (_iRetCount == 0) // print in console
        {
            sciprint("Properties of class \"%ls\":\n\n", def->getName().data());
            if (props.size() == 0)
            {
                sciprint("    no property\n");
            }

            for (auto&& p : props)
            {
                sciprint("    %ls\n", p.data());
            }
        }
        else
        {
            types::String* pFields = new types::String((int)props.size(), 1);
            for (int i = 0; i < props.size(); ++i)
            {
                pFields->set(i, props[i].data());
            }

            out.push_back(pFields);
        }
    }

    return types::Function::OK;
}