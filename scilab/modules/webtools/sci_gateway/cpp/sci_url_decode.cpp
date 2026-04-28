/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include "double.hxx"
#include "function.hxx"
#include "string.hxx"
#include "webtools_gw.hxx"
#include "url_tools.hxx"

extern "C"
{
#include "Scierror.h"
#include "getFullFilename.h"
#include "localization.h"
#include "sci_malloc.h"
#include "sciprint.h"
}
/*--------------------------------------------------------------------------*/
static const char fname[] = "url_decode";
types::Function::ReturnValue sci_url_decode(types::typed_list& in, int _iRetCount, types::typed_list& out)
{
    if (in.size() != 1)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d expected.\n"), fname, 1);
        return types::Function::Error;
    }

    if (_iRetCount > 1)
    {
        Scierror(78, _("%s: Wrong number of output argument(s): %d expected.\n"), fname, 1);
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
    wchar_t** w = pIn->get();

    types::String* pOut = new types::String(pIn->getDims(), pIn->getDimsArray());

    for (int i = 0; i < pOut->getSize(); ++i)
    {
        if (wcslen(w[i]) == 0)
        {
            pOut->set(i, "");
            continue;
        }

        char* c = wide_string_to_UTF8(w[i]);
        std::string o;
        int ret = url_decode(c, o);
        FREE(c);
        switch (ret)
        {
            case -2:
            {
                Scierror(999, _("%s: Argument #%d(%d): Wrong character encoding.\n"), fname, 1, i + 1);
                return types::Function::Error;
            }

            case -1:
            {
                Scierror(999, _("%s: Unable to decode URI.\n"), fname);
                return types::Function::Error;
            }
        }

        pOut->set(i, o.data());
    }

    out.push_back(pOut);
    return types::Function::OK;
}
