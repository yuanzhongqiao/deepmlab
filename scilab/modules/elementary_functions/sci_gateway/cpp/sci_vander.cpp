/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */
/*--------------------------------------------------------------------------*/
#include "elem_func_gw.hxx"
#include "function.hxx"
#include "double.hxx"
#include "overload.hxx"
#include "vander.hxx"
#include "int.hxx"

extern "C"
{
#include "Scierror.h"
#include "localization.h"
#include "basic_functions.h"
}

types::Function::ReturnValue sci_vander(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    types::Double* pDblIn       = NULL;
    types::Double* pDblN        = NULL;
    types::Double* pDblOut      = NULL;
    
    double N = 0;

    if (in.size() < 1 || in.size() > 2)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d to %d expected.\n"), "vander", 1, 2);
        return types::Function::Error;
    }

    if (_iRetCount > 1)
    {
        Scierror(78, _("%s: Wrong number of output argument(s): %d expected.\n"), "vander", 1);
        return types::Function::Error;
    }

    if (in[0]->isDouble() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: Real or complex vector expected.\n"), "vander", 1);
        return types::Function::Error;
    }

    pDblIn = in[0]->getAs<types::Double>();
    int iSize = pDblIn->getSize();

    if (iSize == 0)
    {
        out.push_back(types::Double::Empty());
        return types::Function::OK;
    }

    if ((pDblIn->getCols() != 1 && pDblIn->getRows() != 1))
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: A vector expected.\n"), "vander", 1);
        return types::Function::Error;
    }

    if (in.size() == 2)
    {
        if (in[1]->isDouble() == false)
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: A real scalar expected.\n"), "vander", 2);
            return types::Function::Error;
        }

        pDblN = in[1]->getAs<types::Double>();

        if (pDblN->isScalar() == false)
        {
            Scierror(999, _("%s: Wrong size for input argument #%d: A scalar expected.\n"), "vander", 2);
            return types::Function::Error;
        }

        if (pDblN->isComplex())
        {
            Scierror(999, _("%s: Wrong size for input argument #%d: A real scalar expected.\n"), "vander", 2);
            return types::Function::Error;
        }

        N = pDblN->get(0);

        if (std::floor(N) != N || N <= 0)
        {
            Scierror(999, _("%s: Wrong value for input argument #%d: An integer value expected.\n"), "vander", 2);
            return types::Function::Error;
        }
    }
    else
    {
        N = iSize;
    }

    pDblOut = new types::Double(iSize, N, pDblIn->isComplex());
    vander(pDblIn, N, pDblOut);
    out.push_back(pDblOut);
    
    return types::Function::OK;
}
/*--------------------------------------------------------------------------*/
