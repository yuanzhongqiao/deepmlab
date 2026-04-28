/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2026 - Dassault Systèmes S.E.
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include "elem_func_gw.hxx"
#include "function.hxx"
#include "double.hxx"
#include "sparse.hxx"
#include "overload.hxx"

extern "C"
{
#include "localization.h"
#include "Scierror.h"
#include "issymmetric.h"
}

types::Function::ReturnValue sci_ishermitian(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    if (in.size() != 1)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d expected.\n"), "ishermitian", 1);
        return types::Function::Error;
    }

    if (_iRetCount > 1)
    {
        Scierror(78, _("%s: Wrong number of output argument(s): %d expected.\n"), "ishermitian", 1);
        return types::Function::Error;
    }

    bool bHermitian = false;

    if (in[0]->isDouble())
    {
        types::Double* pDbl = in[0]->getAs<types::Double>();
        int rows = pDbl->getRows();
        int cols = pDbl->getCols();
        
        if (rows == 0)
        {
            // Empty matrix is considered hermitian
            bHermitian = true;
        }
        else
        {
            int iResult = isHermitian(pDbl->getReal(), pDbl->getImg(), pDbl->isComplex(), rows, cols);
            bHermitian = (iResult == SYMMETRIC);
        }
    }
    else if (in[0]->isSparse())
    {
        types::Sparse* pSp = in[0]->getAs<types::Sparse>();
        int rows = pSp->getRows();
        int cols = pSp->getCols();
       
        if (rows == 0)
        {
            // Empty sparse matrix is considered hermitian
            bHermitian = true;
        }
        else
        {
            bHermitian = pSp->isHermitian(rows, cols);
        }
    }
    else
    {
        std::wstring wstFuncName = L"%" + in[0]->getShortTypeStr() + L"_ishermitian";
        return Overload::call(wstFuncName, in, _iRetCount, out);
    }

    types::Bool* pOut = new types::Bool(bHermitian);
    out.push_back(pOut);

    return types::Function::OK;
}
