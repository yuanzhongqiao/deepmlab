/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include "function.hxx"
#include "gsort.hxx"
#include "sparse.hxx"
#include "sparse_gw.hxx"

extern "C"
{
#include "Scierror.h"
#include "charEncoding.h"
#include "localization.h"
}

// spset(A, v)
// A sparce matrix
// new nonzeros vector (size: nnz)
types::Function::ReturnValue sci_spset(types::typed_list& in, int _iRetCount, types::typed_list& out)
{
    if (in.size() != 2)
    {
        Scierror(999, _("%s: Wrong number of input argument(s): %d expected.\n"), "spset", 2);
        return types::Function::Error;
    }

    if (in[0]->isSparse() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: sparse matrix expected.\n"), "spset", 1);
        return types::Function::Error;
    }

    if (in[0]->isSparse() && in[1]->isDouble() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: double matrix expected.\n"), "spset", 2);
        return types::Function::Error;
    }

    types::Sparse* sp = in[0]->getAs<types::Sparse>();
    types::Double* values = in[1]->getAs<types::Double>();
    if (sp->nonZeros() != values->getSize())
    {
        Scierror(999, _("%s: Wrong size for input argument #%d: An array of size %d expected.\n"), "spset", 2, sp->nonZeros());
        return types::Function::Error;
    }

    sp->setValues(values);
    return types::Function::OK;
}
