/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include "GetMatlabVariable.hxx"

extern "C"
{
#include "api_scilab.h"
#include "sci_types.h"
}

matvar_t* GetBooleanVariable(void* pvApiCtx, int iVar, const char* name, int* parent, int item_position)
{
    types::GatewayStruct* pStr = (types::GatewayStruct*)pvApiCtx;
    types::typed_list in = *pStr->m_pIn;

    if (in[iVar - 1]->isBool() == false)
    {
        Scierror(999, _("%s: Wrong type for first input argument: Boolean matrix expected.\n"), "GetBooleanVariable");
        return NULL;
    }

    types::Bool* pBool = in[iVar - 1]->getAs<types::Bool>();

    return GetBooleanMatVar(pBool, name);
}

matvar_t* GetBooleanMatVar(types::Bool* pBoolIn, const char* name)
{
    int Dims = pBoolIn->getDims();
    int* pDims = pBoolIn->getDimsArray();
    size_t* psize_t = (size_t*)MALLOC(Dims * sizeof(size_t));
    matvar_t* pMatVarOut = NULL;

    for (int i = 0; i < Dims; i++)
    {
        psize_t[i] = (int)pDims[i];
    }

    pMatVarOut = Mat_VarCreate(name, MAT_C_UINT32, MAT_T_UINT32, Dims, psize_t, pBoolIn->get(), MAT_F_LOGICAL);

    FREE(psize_t);
    return pMatVarOut;
}
