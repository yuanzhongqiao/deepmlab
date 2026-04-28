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
#include "configvariable.hxx"
#include "UTF8.hxx"
#include "arguments.hxx"

#include "inlinehelp.hxx"

extern "C"
{
#include "Scierror.h"
#include "charEncoding.h"
#include "localization.h"
#include "sci_malloc.h"
#include "sciprint.h"
}

types::Function::ReturnValue sci_percent_help(types::typed_list& in, int _iRetCount, types::typed_list& out)
{
    std::string sheetFile = "";
    std::wstring page = L"";

    if (in.size() < 1 || in.size() > 2)
    {
        Scierror(999, _("%s: Wrong number of input argument(s): %d to %d expected.\n"), "help", 1, 2);
        return types::Function::Error;
    }

    if (_iRetCount > 1)
    {
        Scierror(999, _("%s: Wrong number of output argument(s): %d expected.\n"), "help", 1);
        return types::Function::Error;
    }

    if (!in[0]->isString() || !in[0]->getAs<types::String>()->isScalar())
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: scalar string expected.\n"), "help", 1);
        return types::Function::Error;
    }

    page = in[0]->getAs<types::String>()->get(0);

    if (in.size() == 2)
    {
        if (!in[1]->isString() || !in[1]->getAs<types::String>()->isScalar())
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: scalar string expected.\n"), "help", 2);
            return types::Function::Error;
        }

        auto isFile = getFunctionValidator(L"mustBeFile");
        types::typed_list in2 = {in[1]};
        if (std::get<0>(isFile)(in2) == false)
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: Must be a file.\n"), "help", 2);
            return types::Function::Error;
        }

        sheetFile = scilab::UTF8::toUTF8(in[1]->getAs<types::String>()->get(0));

    }
    else
    {
        std::wstring& sciW = ConfigVariable::getSCIPath();
        char* sciC = wide_string_to_UTF8(sciW.c_str());
        std::string sci(sciC);
        FREE(sciC);

        sheetFile = buildAbsolutePath(sci, "modules/core/etc/help_text.xsl");
    }

    if (loadStyleSheet(sheetFile) == false)
    {
        Scierror(999, _("%s: Cannot load stylesheet: %s\n"), "help", sheetFile.c_str());
        return types::Function::Error;
    }

    std::wstring content;
    int err = inlineHelp(page, content);

    if (err != 0)
    {
        switch (err)
        {
            case -1:
                Scierror(999, _("%s: Unable to determine language for help.\n"), "help");
                break;
            case -2:
                Scierror(999, _("%s: No more memory.\n"), "help");
                break;
            case -4:
                Scierror(999, _("%s: Cannot read inline help index.\n"), "help");
                break;
            case -5:
            {
                // Unknown page: try to display the page name if possible
                char* p = wide_string_to_UTF8(page.c_str());
                Scierror(999, _("%s: Unknown help page: %s.\n"), "help", p ? p : "");
                if (p)
                {
                    FREE(p);
                }
                break;
            }
            case -6:
                Scierror(999, _("%s: Cannot transform help page.\n"), "help");
                break;
            default:
                Scierror(999, _("%s: Internal error retrieving help (code %d).\n"), "help", err);
                break;
        }
        return types::Function::Error;
    }

    if (_iRetCount == 0)
    {
        if (content.size() != 0)
        {
            char* c = wide_string_to_UTF8(content.data());
            std::string str(c);
            int offset = 0;
            while (offset < str.size())
            {
                sciprint("%s", str.substr(offset, 2048).data());
                offset += 2048;
            }

            sciprint("\n");
        }
    }
    else
    {
        out.push_back(new types::String(content.data()));
    }

    return types::Function::OK;
}
