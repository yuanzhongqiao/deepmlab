/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 */

#include "classdef.hxx"
#include "context.hxx"
#include "core_gw.hxx"
#include "function.hxx"
#include "object.hxx"
#include "string.hxx"

extern "C"
{
#include "Scierror.h"
#include "charEncoding.h"
#include "localization.h"
#include "sciprint.h"
}

types::Function::ReturnValue sci_show_vtable(types::typed_list& in, int _iRetCount, types::typed_list& out)
{
    if (in.size() != 1)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d expected.\n"), "show_vtable", 1);
        return types::Function::Error;
    }

    types::InternalType* pIT = in[0];

    if (pIT->isString() == false && pIT->isClassdef() == false && pIT->isObject() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: %s, %s or %s expected.\n"), "show_vtable", 1, "string", "classname", "object");
        return types::Function::Error;
    }

    types::Classdef* def = nullptr;
    if (pIT->isString())
    {
        pIT = symbol::Context::getInstance()->get(symbol::Symbol(pIT->getAs<types::String>()->get(0)));
        if (pIT->isClassdef() == false)
        {
            Scierror(999, _("%s: Wrong value for input argument #%d: \"%s\" expected.\n"), "show_vtable", 2, "classname");
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
        def->showMethodTable();
    }

    return types::Function::OK;
}