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
#include "spCompGeneric.hxx"

extern "C"
{
#include "localization.h"
#include "Scierror.h"
#include "sciprint.h"
}

types::Function::ReturnValue sci_percent_spCompGeneric_clear(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    spCompGeneric *spcgEngine = NULL;
    char errorMsg[256];

    if (in.size() == 1)
    {
        if (in[0]->isMList())
        {
            types::InternalType *pI;
            types::MList *pObj = in[0]->getAs<types::MList>();
            if (pObj->extract(L"engine",pI) && pI->isPointer())
            {
                spcgEngine = (spCompGeneric *) (pI->getAs<types::Pointer>()->get());
                if (spcgEngine != NULL)
                {
                    delete spcgEngine;
                }
            }
            else
            {
                sprintf(errorMsg, _("%s: Wrong type for argument #1.\n"), "%_spCompGeneric_clear");
                throw ast::InternalError(errorMsg);
            }
        }
        else
        {
            sprintf(errorMsg, _("%s: Wrong type for argument #1.\n"), "%_spCompGeneric_clear");
            throw ast::InternalError(errorMsg);
        }
    }
    else
    {
        sprintf(errorMsg, _("%s: Wrong number of input arguments.\n"), "%_spCompGeneric_clear");
        throw ast::InternalError(errorMsg);
    }

    return types::Function::OK;
}
