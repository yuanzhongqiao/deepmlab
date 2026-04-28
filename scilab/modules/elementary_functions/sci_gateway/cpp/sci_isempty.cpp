/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *
 * Copyright (C) 2024 - Dassault System S.E. - Cédric DELAMARRE 
 * 
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include "elem_func_gw.hxx"
#include "function.hxx"
#include "overload.hxx"
#include "string.hxx"

extern "C"
{
#include "localization.h"
#include "Scierror.h"
}

static const char fname[] = "isempty";
types::Function::ReturnValue sci_isempty(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    if (in.size() != 1)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d expected.\n"), fname, 1);
        return types::Function::Error;
    }

    if(in[0]->isArrayOf())
    {
        types::GenericType* pGT = in[0]->getAs<types::GenericType>();
        if(pGT->getSize() == 0)
        {
            // [], cell(), struct()
            out.push_back(new types::Bool(true));
            return types::Function::OK;
        }

        // non empty arrayOf, check content
        switch (pGT->getType())
        {
            case types::InternalType::ScilabString:
            {
                types::String* pStr = pGT->getAs<types::String>();
                wchar_t** data = pStr->get();
                for(int i = 0; i < pStr->getSize(); i++)
                {
                    if(wcslen(data[i]))
                    {
                        out.push_back(new types::Bool(false));
                        return types::Function::OK;
                    }
                }

                // ["","",""]
                out.push_back(new types::Bool(true));
                return types::Function::OK;
            }
            case types::InternalType::ScilabStruct:
            case types::InternalType::ScilabCell:
            {
                // Overload
                break;
            }
            default:
            {
                out.push_back(new types::Bool(false));
                return types::Function::OK;
            }
        }
    }

    return Overload::call(L"%_isempty", in, _iRetCount, out);
}