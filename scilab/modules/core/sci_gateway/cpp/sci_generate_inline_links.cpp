/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 */

#include "core_gw.hxx"
#include "function.hxx"
#include "struct.hxx"
#include "string.hxx"

#include "configvariable.hxx"
#include "inlinehelp.hxx"

extern "C"
{
#include "localization.h"
#include "Scierror.h"
#include "sciprint.h"
}

constexpr const char fname[] = "generate_inline_help";
types::Function::ReturnValue sci_generate_inline_links(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    if (in.size() <= 1 && in.size() >= 2)
    {
        Scierror(999, _("%s: Wrong number of input argument(s): %d to %d expected.\n"), fname, 1, 2);
        return types::Function::Error;
    }

    if (_iRetCount != 0)
    {
        Scierror(999, _("%s: Wrong number of output argument(s): %d expected.\n"), fname, 0);
        return types::Function::Error;
    }

    std::wstring lang = in[0]->getAs<types::String>()->get(0);

    std::wstring path = ConfigVariable::getSCIPath();
    if (in.size() == 2)
    {
        path = in[1]->getAs<types::String>()->get(0);
    }

    int err = generate_inline_links(lang, path);
    switch (err)
    {
        case 0:
            return types::Function::OK;
        case -1:
        case -2:
        case -3:
        case -4:
        case -5:
        case -6:
        default:
            Scierror(999, "generate_inline_links failed: %d\n", err);
            return types::Function::Error;
    }
}
