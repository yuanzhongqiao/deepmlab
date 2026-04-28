/*
 * Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2022 - UTC - Stéphane MOTTELET
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */
/*--------------------------------------------------------------------------*/
#include "function.hxx"
#include "string.hxx"
#include "configvariable.hxx"

extern "C"
{
#include "Scierror.h"
#include "localization.h"
}
/*--------------------------------------------------------------------------*/
types::Function::ReturnValue sci_polyDisplay(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    int iDisp = 0;

    if (in.size() > 1)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d to %d expected.\n"), "polyDisplay", 0, 1);
        return types::Function::Error;
    }

    if (_iRetCount > 1)
    {
        Scierror(78, _("%s: Wrong number of output argument(s): at most %d expected.\n"), "polyDisplay", 1);
        return types::Function::Error;
    }

    if (in.size() == 1)
    {
        if (in[0]->isString() == false)
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: A string expected.\n"), "polyDisplay", 1);
            return types::Function::Error;
        }

        types::String* pStr = in[0]->getAs<types::String>();

        if (pStr->isScalar() == false)
        {
            Scierror(999, _("%s: Wrong size for input argument #%d: A scalar string expected.\n"), "polyDisplay", 1);
            return types::Function::Error;
        }

        if (wcscmp(pStr->get(0),L"ascii") == 0)
        {
            iDisp = 0;
        }
        else if (wcscmp(pStr->get(0),L"unicode") == 0)
        {
            iDisp = 1;
        }
        else 
        {
            Scierror(999, _("%s: Wrong value for input argument #%d: \"ascii\" or \"unicode\" expected.\n"), "polyDisplay", 1);
            return types::Function::Error;
        }

        if (_iRetCount == 1)
        {
            out.push_back(new types::String(ConfigVariable::getPolynomialDisplay() == 0 ? L"ascii" : L"unicode"));
        }

        ConfigVariable::setPolynomialDisplay(iDisp);
    }
    else // if (in.size() == 0) get polynomial display mode
    {
        out.push_back(new types::String(ConfigVariable::getPolynomialDisplay() == 0 ? L"ascii" : L"unicode"));
    }

    return types::Function::OK;
}
/*--------------------------------------------------------------------------*/

