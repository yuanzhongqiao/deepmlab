/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 */

#include "core_gw.hxx"
#include "function.hxx"
#include "string.hxx"
#include "bool.hxx"

extern "C"
{
#include "Scierror.h"
#include "localization.h"
}

types::Function::ReturnValue sci_isa(types::typed_list& in, int _iRetCount, types::typed_list& out)
{
    if (in.size() != 2)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d expected."), "isa", 2);
        return types::Function::Error;
    }

    if (in[1]->isString() == false || in[1]->getAs<types::String>()->getSize() != 1)
    {
        Scierror(999, _("%s: Wrong type for argument #%d: strings expected.\n"), "isa", 1);
        return types::Function::Error;
    }

    bool ret = in[0]->isA(in[1]->getAs<types::String>()->get()[0]);
    out.push_back(new types::Bool(ret));
    return types::Function::OK;
}
