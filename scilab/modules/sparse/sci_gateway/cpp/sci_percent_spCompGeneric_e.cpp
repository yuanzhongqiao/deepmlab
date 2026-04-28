//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022-2023 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

#include "sparse_gw.hxx"

#include "function.hxx"
#include "mlist.hxx"
#include "pointer.hxx"
#include "sparse.hxx"
#include "spCompGeneric.hxx"

extern "C"
{
#include "localization.h"
#include "Scierror.h"
#include "sciprint.h"
}

types::Function::ReturnValue sci_percent_spCompGeneric_e(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    spCompGeneric *spgEngine = NULL;

    if (in.size() >= 2)
    {
        if (in[in.size()-1]->isMList())
        {
            types::InternalType *pI;
            types::MList *pObj = in[in.size()-1]->getAs<types::MList>();
            if (pObj->extract(L"engine",pI) && pI->isPointer())
            {
                spgEngine = (spCompGeneric *) (pI->getAs<types::Pointer>()->get());
                // if (spgEngine->setRecoveryParameters(in) == false)
                // {
                //     return types::Function::Error;
                // }
                // in.pop_back();
                // spgEngine->computeDerivatives(in);
                in.pop_back();
                if (spgEngine->computeDerivatives(in) == false)
                {
                    return types::Function::Error;
                }
                types::Sparse *pSp = spgEngine->getRecoveredMatrix();
                out.push_back(pSp);
            }
            else
            {
                Scierror(999,_("%s: Wrong type for argument #1.\n"), "%_spCompGeneric_e");
                return types::Function::Error;
            }
        }
        else
        {
            Scierror(999,_("%s: Wrong type for argument #1.\n"), "%_spCompGeneric_e");
            return types::Function::Error;
        }
    }
    else
    {
         Scierror(999, _("%s: Wrong number of input arguments.\n"), "%_spCompGeneric_e");
         return types::Function::Error;
    }
    return types::Function::OK;
}
