/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
* Copyright (C) 2023 - Dassault Système - Clement DAVID
* Copyright (C) 2006 - INRIA - Antoine ELIAS
*
 * Copyright (C) 2012 - 2016 - Scilab Enterprises
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
*
*/

#include <string.h>

#include "CoverModule.hxx"

#include "coverage_gw.hxx"
#include "scilabWrite.hxx"
#include "scilabexception.hxx"
#include "configvariable.hxx"
#include "context.hxx"
#include "macrofile.hxx"

#include <iostream>
#include <fstream>
#include <string>
#include <vector>

extern "C"
{
#include "Scierror.h"
#include "localization.h"
}

/*--------------------------------------------------------------------------*/
types::Function::ReturnValue sci_covStart(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    if (in.size() != 1)
    {
        Scierror(999, _("%s: Wrong number of input arguments: %d expected.\n"), "covStart", 1);
        return types::Function::Error;
    }

    if (!in[0]->isMacro() && !in[0]->isMacroFile() && (!in[0]->isString() || (in[0]->getAs<types::String>()->getCols() != 2 && in[0]->getAs<types::String>()->getCols() != 1)))
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: A two-columns string matrix expected.\n"), "covStart", 1);
        return types::Function::Error;
    }

    if (!in[0]->isMacro() && !in[0]->isMacroFile())
    {
        types::String * strs = in[0]->getAs<types::String>();
        const unsigned int rows = strs->getRows();
        symbol::Context* ctx = symbol::Context::getInstance();

        if (strs->getCols() == 2)
        {
            std::vector<std::pair<std::wstring, std::wstring>> paths_mods;
            paths_mods.reserve(rows);

            for (unsigned int i = 0; i < rows; ++i)
            {
                // resolve lib to its path
                wchar_t* wvar = strs->get(i, 0);
                types::InternalType* pIT = ctx->get(symbol::Symbol(wvar));
                if (pIT != NULL && pIT->isLibrary())
                {
                    // use the library path
                    types::Library* lib = pIT->getAs<types::Library>();
                    paths_mods.emplace_back(lib->getPath(), strs->get(i, 1));
                }
                else
                {
                    // use the argument as path
                    paths_mods.emplace_back(wvar, strs->get(i, 1));
                }
            }

            coverage::CoverModule* cover = coverage::CoverModule::createInstance(paths_mods);
            if (cover->getMacros().empty())
            {
                Scierror(999, _("%s: Wrong input argument #%d: this is not a Scilab module and associated macros.\n"), "covStart", 1);
                return types::Function::Error;
            }
        }
        else
        {
            std::vector<std::wstring> mods;
            mods.reserve(rows);

            for (unsigned int i = 0; i < rows; ++i)
            {
                // resolve lib to its path
                wchar_t* wvar = strs->get(i, 0);
                types::InternalType* pIT = ctx->get(symbol::Symbol(wvar));
                if (pIT != NULL && pIT->isLibrary())
                {
                    // use the library path
                    types::Library* lib = pIT->getAs<types::Library>();
                    mods.emplace_back(lib->getPath());
                }
                else
                {
                    // use the argument as path
                    mods.emplace_back(wvar);
                }
            }

            coverage::CoverModule* cover = coverage::CoverModule::createInstance(mods);
            if (cover->getMacros().empty())
            {
                Scierror(999, _("%s: Wrong input argument #%d: this is not a Scilab module with macros.\n"), "covStart", 1);
                return types::Function::Error;
            }
        }
    }
    else
    {
        if (in[0]->isMacro())
        {
            coverage::CoverModule::createInstance()->instrumentSingleMacro(L"", L"", static_cast<types::Macro *>(in[0]), false);
        }
        else if (in[0]->isMacroFile())
        {
            coverage::CoverModule::createInstance()->instrumentSingleMacro(L"", L"", static_cast<types::MacroFile *>(in[0])->getMacro(), false);
        }
        else
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: Function expected.\n"), "covStart", 1);
            return types::Function::Error;
        }
    }

    coverage::CoverModule* const instance = coverage::CoverModule::getInstance();
    out.emplace_back(new types::Double(instance->getCounters().size()));

    return types::Function::OK;
}
