
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

#include "inlinehelp.hxx"
#include "arguments.hxx"

extern "C"
{
#include "Scierror.h"
#include "localization.h"
}

constexpr const char fname[] = "loadToolboxInlineHelp";
types::Function::ReturnValue sci_loadToolboxInlineHelp(types::typed_list& in, int _iRetCount, types::typed_list& out)
{
    if (in.size() != 1)
    {
        Scierror(999, _("%s: Wrong number of input argument(s): %d expected.\n"), fname, 2);
        return types::Function::Error;
    }

    if (_iRetCount != 0)
    {
        Scierror(999, _("%s: Wrong number of output argument(s): %d expected.\n"), fname, 0);
        return types::Function::Error;
    }

    auto isFolder = getFunctionValidator(L"mustBeFolder");
    if (std::get<0>(isFolder)(in) == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: Must be a folder.\n"), fname, 1);
        return types::Function::Error;
    }

    loadToolboxHelp(in[0]->getAs<types::String>()->get(0));
    return types::Function::OK;
}
