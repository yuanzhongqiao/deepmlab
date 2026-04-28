/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include "double.hxx"
#include "elem_func_gw.hxx"
#include "function.hxx"
#include "int.hxx"
#include "overload.hxx"
#include "string.hxx"

extern "C"
{
#include "Scierror.h"
#include "basic_functions.h"
#include "localization.h"
}

types::Function::ReturnValue sci_percent_gallery(types::typed_list& in, int _iRetCount, types::typed_list& out)
{
    types::Double* pDblIn = NULL;
    types::Double* pDblOut = NULL;

    if (in.size() < 1)
    {
        Scierror(77, _("%s: Wrong number of input argument: At least %d expected.\n"), "%_gallery", 1);
        return types::Function::Error;
    }

    if (in[0]->isString() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: A string expected.\n"), "%_gallery", 1);
        return types::Function::Error;
    }

    std::wstring wcsName = in[0]->getAs<types::String>()->get(0);

    if (in[1]->isDouble() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: A double expected.\n"), "%_gallery", 2);
        return types::Function::Error;
    }

    pDblIn = in[1]->getAs<types::Double>();
    int iSize = pDblIn->getSize();

    if (wcsName == L"hankel")
    {
        if (in.size() != 3)
        {
            Scierror(77, _("%s: Wrong number of input arguments: %d expected.\n"), "%_gallery", 3);
            return types::Function::Error;
        }

        types::Double* pDblIn2 = NULL;
        if (in[2]->isDouble() == false)
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: A double expected.\n"), "%_gallery", 3);
            return types::Function::Error;
        }

        pDblIn2 = in[2]->getAs<types::Double>();
        int N = pDblIn->getSize();
        int N2 = pDblIn2->getSize();

        pDblOut = new types::Double(N, N2, pDblIn->isComplex() || pDblIn2->isComplex());
        hankel_matrix(N, N2, pDblIn->get(), pDblIn2->get(), pDblOut->get());

        if (pDblOut->isComplex())
        {
            hankel_matrix(N, N2, pDblIn->getImg(), pDblIn2->getImg(), pDblOut->getImg());
        }
    }
    else
    {
        if (iSize == 0)
        {
            out.push_back(types::Double::Empty());
            return types::Function::OK;
        }

        if (iSize != 1)
        {
            Scierror(999, _("%s: Wrong size for input argument #%d: A scalar expected.\n"), "%_gallery", 2);
            return types::Function::Error;
        }

        int N = static_cast<int>(pDblIn->get(0));
        if (N < 0)
        {
            Scierror(999, _("%s: Wrong value for input argument #%d: A positive value expected.\n"), "%_gallery", 2);
            return types::Function::Error;
        }

        pDblOut = new types::Double(N, N, pDblIn->isComplex());
        if (wcsName == L"magic")
        {
            magic_matrix(N, pDblOut->get());
        }
        else if (wcsName == L"hilb")
        {
            hilb_matrix(N, pDblOut->get());
        }
        else if (wcsName == L"invhilb")
        {
            invhilb_matrix(N, pDblOut->get());
        }
        else if (wcsName == L"frank")
        {
            frank_matrix(N, pDblOut->get());
        }
        else if (wcsName == L"wilkinson")
        {
            wilkinson_matrix(N, pDblOut->get());
        }
        else if (wcsName == L"pascal")
        {
            int K = 0;
            if (in.size() != 3)
            {
                Scierror(77, _("%s: Wrong number of input arguments: %d expected.\n"), "%_gallery", 3);
                return types::Function::Error;
            }

            types::Double* pDblInK = in[2]->getAs<types::Double>();
            K = static_cast<int>(pDblInK->get(0));
            pascal_matrix(N, K, pDblOut->get());
        }
        else
        {
            Scierror(999, _("%s: Wrong value for input argument #%d: %s expected.\n"), "%_gallery", 1, "\"hilb\", \"invhilb\", \"magic\", \"frank\", \"wilkinson\" or \"pascal\"");
            return types::Function::Error;
        }
    }

    out.push_back(pDblOut);
    return types::Function::OK;
}