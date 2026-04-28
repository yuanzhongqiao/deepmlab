/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2010-2010 - DIGITEO - Bruno JOFRET
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
#include "io_gw.hxx"
#include "string.hxx"
#include "function.hxx"
#include "double.hxx"
#include "spawncommand.hxx"

extern "C"
{
#include "localization.h"
#include "Scierror.h"
}

static const char fname[] = "host";
types::Function::ReturnValue sci_host(types::typed_list& in, types::optional_list& opt, int _iRetCount, types::typed_list& out)
{
    if (in.size() < 1 || in.size() > 2)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d to %d expected.\n"), fname, 1, 2);
        return types::Function::Error;
    }

    if (_iRetCount > 3)
    {
        Scierror(78, _("%s: Wrong number of output argument(s): %d to %d expected.\n"), fname, 1, 3);
        return types::Function::Error;
    }

    // Get command
    types::InternalType* pIT = in[0];
    if (pIT->isString() == false || pIT->getAs<types::String>()->getSize() != 1)
    {
        Scierror(89, _("%s: Wrong size for input argument #%d: string expected.\n"), fname, 1);
        return types::Function::Error;
    }

    wchar_t* pstCommand = pIT->getAs<types::String>()->get(0);

    // Get optional
    int iEcho = 0;
    for (const auto& o : opt)
    {
        if (o.first == L"echo")
        {
            if (o.second->isBool() == false || o.second->getAs<types::Bool>()->isScalar() == false)
            {
                Scierror(999, _("%s: Wrong type for input argument #%s: A scalar boolean expected.\n"), fname, "echo");
                return types::Function::Error;
            }

            iEcho = o.second->getAs<types::Bool>()->get(0);
        }
        else
        {
            Scierror(999, _("%s: Wrong named argument %s: expected name is '%s'.\n"), fname, "echo");
            return types::Function::Error;
        }
    }

    // Call command
    types::String* pStrOut = nullptr;
    types::String* pStrErr = nullptr;
    int stat = spawncommand(pstCommand, _iRetCount - 1, &pStrOut, &pStrErr, iEcho);

    out.push_back(new types::Double(stat));
    if (pStrOut)
    {
        out.push_back(pStrOut);
    }

    if (pStrErr)
    {
        out.push_back(pStrErr);
    }

    return types::Function::OK;
}
