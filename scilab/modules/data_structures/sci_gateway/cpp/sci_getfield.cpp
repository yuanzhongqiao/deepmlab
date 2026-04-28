/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 */

/*--------------------------------------------------------------------------*/
#include "data_structures_gw.hxx"
#include "internal.hxx"
#include "function.hxx"
#include "double.hxx"
#include "int.hxx"
#include "string.hxx"
#include "list.hxx"
#include "mlist.hxx"
#include "tlist.hxx"
#include "struct.hxx"
#include "user.hxx"
#include "object.hxx"

extern "C"
{
#include "Scierror.h"
#include "sci_malloc.h"
#include "localization.h"
#include "freeArrayOfString.h"
}

static types::Function::ReturnValue sci_getfieldStruct(types::typed_list &in, int _iRetCount, types::typed_list &out);
static types::Function::ReturnValue sci_getfieldUserType(types::typed_list& in, int _iRetCount, types::typed_list& out);
static types::Function::ReturnValue sci_getfieldObject(types::typed_list& in, int _iRetCount, types::typed_list& out);

/*-----------------------------------------------------------------------------------*/
types::Function::ReturnValue sci_getfield(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    int iRetCount = std::max(_iRetCount, 1);

    if (in.size() != 2)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d expected.\n"), "getfield", 2);
        return types::Function::Error;
    }

    //special case for struct
    if (in[1]->isStruct())
    {
        return sci_getfieldStruct(in, _iRetCount, out);
    }

    // special case for Object
    if (in[1]->isObject())
    {
        return sci_getfieldObject(in, _iRetCount, out);
    }

    // special case for UserType
    if (in[1]->isUserType())
    {
        return sci_getfieldUserType(in, _iRetCount, out);
    }

    types::InternalType* pIndex = in[0];
    if (in[1]->isList() == false && in[1]->isMList() == false && in[1]->isTList() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: List expected.\n"), "getfield", 2);
        return types::Function::Error;
    }

    types::List* pL = in[1]->getAs<types::List>();
    types::InternalType* pITOut = NULL;

    if (pIndex->isString())
    {
        //extraction by fieldnames
        if (pL->isMList() == false && pL->isTList() == false)
        {
            Scierror(999, _("%s: Soft coded field names not yet implemented.\n"), "getfield");
            return types::Function::Error;
        }

        types::TList* pT = pL->getAs<types::TList>();
        types::String* pS = pIndex->getAs<types::String>();

        std::list<std::wstring> stFields;

        //check output arguments count
        for (int i = 0 ; i < pS->getSize() ; i++)
        {
            std::wstring wst = pS->get(i);
            if (pT->exists(wst) == false)
            {
                Scierror(999, _("%s: Invalid index.\n"), "getfield");
                return types::Function::Error;
            }

            stFields.push_back(pS->get(i));
        }

        pITOut = pT->extractStrings(stFields);
    }
    else
    {
        //extraction by index
        types::typed_list Args;
        Args.push_back(pIndex);
        pITOut = pL->extract(&Args);
    }

    if (pITOut == NULL)
    {
        Scierror(999, _("Invalid index.\n"));
        return types::Function::Error;
    }

    types::List* pList = pITOut->getAs<types::List>();
    int iListSize = pList->getSize();

    if (iRetCount != iListSize)
    {
        Scierror(78, _("%s: Wrong number of output argument(s): %d expected.\n"), "getfield", iListSize);
        return types::Function::Error;
    }

    int iIndex = 0;
    for (int i = 0; i < iListSize; i++)
    {
        if (pList->get(i)->isVoid())
        {
            switch (pIndex->getType())
            {
                case types::InternalType::ScilabType::ScilabDouble:
                {
                    iIndex = (int)pIndex->getAs<types::Double>()->get(i);
                }
                break;
                case types::InternalType::ScilabType::ScilabInt8:
                {
                    iIndex = (int)pIndex->getAs<types::Int8>()->get(i);
                }
                break;
                case types::InternalType::ScilabType::ScilabUInt8:
                {
                    iIndex = (int)pIndex->getAs<types::UInt8>()->get(i);
                }
                break;
                case types::InternalType::ScilabType::ScilabInt16:
                {
                    iIndex = (int)pIndex->getAs<types::Int16>()->get(i);
                }
                break;
                case types::InternalType::ScilabType::ScilabUInt16:
                {
                    iIndex = (int)pIndex->getAs<types::UInt16>()->get(i);
                }
                break;
                case types::InternalType::ScilabType::ScilabInt32:
                {
                    iIndex = pIndex->getAs<types::Int32>()->get(i);
                }
                break;
                case types::InternalType::ScilabType::ScilabUInt32:
                {
                    iIndex = (int)pIndex->getAs<types::UInt32>()->get(i);
                }
                break;
                case types::InternalType::ScilabType::ScilabInt64:
                {
                    iIndex = (int)pIndex->getAs<types::Int64>()->get(i);
                }
                break;
                case types::InternalType::ScilabType::ScilabUInt64:
                {
                    iIndex = (int)pIndex->getAs<types::UInt64>()->get(i);
                }
                break;
                case types::InternalType::ScilabType::ScilabString:
                {
                    std::wstring wField(pIndex->getAs<types::String>()->get(i));
                    iIndex = pL->getAs<types::TList>()->getIndexFromString(wField);
                    // The type (the first field) is not counted
                    iIndex++;
                }
                break;
                default:
                    break;
            }

            pList->killMe();
            Scierror(999, _("List element number %d is Undefined.\n"), iIndex);
            return types::Function::Error;
        }
    }

    for (int i = 0 ; i < iRetCount ; i++)
    {
        out.push_back(pList->get(i));
    }

    pList->killMe();

    return types::Function::OK;
}
/*-----------------------------------------------------------------------------------*/

static types::Function::ReturnValue sci_getfieldStruct(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    types::InternalType* pIndex = in[0];
    types::Struct* pSt = in[1]->getAs<types::Struct>();
    types::typed_list vectResult;
    int iRetCount = std::max(_iRetCount, 1);

    if (pIndex->isString())
    {
        types::String* pFields = pIndex->getAs<types::String>();
        std::vector<std::wstring> wstFields;

        for (int i = 0 ; i < pFields->getSize() ; i++)
        {
            std::wstring wstField(pFields->get(i));
            if (pSt->exists(wstField))
            {
                wstFields.push_back(wstField);
            }
            else
            {
                Scierror(78, _("%s: Field \"%ls\" does not exist\n"), "getfield", wstField.data());
                return types::Function::Error;
            }
        }

        vectResult = pSt->extractFields(wstFields);
    }
    else
    {
        //extraction by index
        // do not extract myself of myself
        types::typed_list input;
        input.push_back(in[0]);
        vectResult = pSt->extractFields(&input);
    }

    if (vectResult.size() == 0)
    {
        Scierror(78, _("%s: Invalid index.\n"), "getfield");
        return types::Function::Error;
    }

    if (iRetCount != static_cast<int>(vectResult.size()))
    {
        Scierror(78, _("%s: Wrong number of output argument(s): %d expected.\n"), "getfield", (int) vectResult.size());
        return types::Function::Error;
    }

    for (int i = 0 ; i < iRetCount ; i++)
    {
        out.push_back(vectResult[i]);
    }

    return types::Function::OK;
}
/*-----------------------------------------------------------------------------------*/
static types::Function::ReturnValue sci_getfieldObject(types::typed_list& in, int _iRetCount, types::typed_list& out)
{
    int iRetCount = std::max(_iRetCount, 1);

    types::Object* obj = in[1]->getAs<types::Object>();
    if (in[0]->isString() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: string expected.\n"), "getfield", 1);
        return types::Function::Error;
    }

    types::String* pFields = in[0]->getAs<types::String>();

    std::vector<std::wstring> wstFields;
    for (int i = 0; i < pFields->getSize(); i++)
    {
        std::wstring wstField(pFields->get(i));
        if (obj->hasProperty(wstField))
        {
            wstFields.push_back(wstField);
        }
        else
        {
            Scierror(78, _("%s: Property \"%ls\" does not exist\n"), "getfield", wstField.data());
            return types::Function::Error;
        }
    }

    for (auto&& f : wstFields)
    {
        out.push_back(obj->getProperty(f));
    }

    if (out.size() != iRetCount)
    {
        Scierror(78, _("%s: Wrong number of output argument(s): %d expected.\n"), "getfield", (int)out.size());
        out.clear();
        return types::Function::Error;
    }

    return types::Function::OK;
}

static types::Function::ReturnValue sci_getfieldUserType(types::typed_list &in, int /*_iRetCount*/, types::typed_list &out)
{
    types::UserType* pUT = in[1]->getAs<types::UserType>();

    if (in[0]->isDouble())
    {
        types::Double* pIndex = in[0]->getAs<types::Double>();

        // Extract the properties
        types::typed_list one (1, new types::Double(1));
        types::InternalType* properties = pUT->extract(&one);
        if (!properties || !properties->isString())
        {
            Scierror(999, _("%s: Could not read the argument #%d properties.\n"), "getfield", 2);
            one[0]->killMe();
            return types::Function::Error;
        }
        one[0]->killMe();

        types::String* propertiesStr = properties->getAs<types::String>();

        // Checking the index validity
        int index = pIndex->get(0);
        if (floor(index) != index)
        {
            Scierror(999, _("%s: Wrong value for input argument #%d: An integer value expected.\n"), "getfield", 1);
            properties->killMe();
            return types::Function::Error;
        }
        if (index < 1 || index > 1 + propertiesStr->getSize())
        {
            Scierror(999, _("%s: Wrong value for input argument #%d: At most %d expected.\n"), "getfield", 1, 1 + propertiesStr->getSize());
            properties->killMe();
            return types::Function::Error;
        }

        if (index == 1)
        {
            // Return the properties
            types::String* ret = new types::String(1, 1 + propertiesStr->getSize());
            ret->set(0, pUT->getTypeStr().c_str());
            for (int i = 0; i < propertiesStr->getSize(); ++i)
            {
                ret->set(i + 1, propertiesStr->get(i));
            }
            out.push_back(ret);
        }
        else
        {
            // Return property number 'index-2'
            types::InternalType* field;
            pUT->extract(propertiesStr->get(index - 2), field);
            out.push_back(field);
        }

        properties->killMe();
        return types::Function::OK;
    }
    else
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: Integer expected.\n"), "getfield", 1);
        return types::Function::Error;
    }
}
/*-----------------------------------------------------------------------------------*/
