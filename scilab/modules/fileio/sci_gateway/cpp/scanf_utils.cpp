/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *
 * Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
*/

#include "scanf_utils.hxx"
#include "string.hxx"
#include "double.hxx"
#include "mlist.hxx"

unsigned int scanfToInternalTypes(entry* data, sfdir* type_s, int iSize, int iCol, std::vector<types::InternalType*>& vIT)
{
    unsigned int uiFormatUsed = 0;
    for (int i = 0; i < iCol; i++)
    {
        switch ( type_s[i] )
        {
            case SF_C:
            case SF_S:
            {
                types::String* ps = new types::String(iSize, 1);
                for (int j = 0; j < iSize; j++)
                {
                    ps->set(j, data[i + iCol * j].s);
                }

                vIT.push_back(ps);
                uiFormatUsed |= (1 << 1);
            }
            break;
            case SF_LUI:
            case SF_SUI:
            case SF_UI:
            case SF_LI:
            case SF_SI:
            case SF_I:
            case SF_LF:
            case SF_F:
            {
                types::Double* p = new types::Double(iSize, 1);
                for (int j = 0; j < iSize; j++)
                {
                    p->set(j, data[i + iCol * j].d);
                }

                vIT.push_back(p);
                uiFormatUsed |= (1 << 2);
            }
            break;
            case NONE:
                break;
        }
    }

    return uiFormatUsed;
}

void InternalTypesToOutput(std::vector<types::InternalType*>& vIT, int iRetCount, int retval, unsigned int uiFormatUsed, types::typed_list &out)
{
    int sizeOfVector = (int)vIT.size();
    if (iRetCount > 1)
    {
        out.push_back(new types::Double((double)retval));

        for (int i = 0; i < sizeOfVector; i++)
        {
            out.push_back(vIT[i]);
        }
        for (int i = sizeOfVector + 1; i < iRetCount; i++)
        {
            out.push_back(types::Double::Empty());
        }

        return;
    }
   
    if (sizeOfVector == 0)
    {
        out.push_back(types::Double::Empty());
        return;
    }

    int iRows = vIT[0]->getAs<types::GenericType>()->getRows();
    switch (uiFormatUsed)
    {
        case (1 << 1) :
        {
            int dimsArrayOfRes[2] = {iRows, sizeOfVector};
            types::String* pString = new types::String(2, dimsArrayOfRes);
            for (int i = 0; i < sizeOfVector; i++)
            {
                wchar_t** pStr = vIT[i]->getAs<types::String>()->get();
                for (int j = 0; j < iRows; j++)
                {
                    pString->set(i * iRows + j, pStr[j]);
                }
            }
            out.push_back(pString);
        }
        break;
        case (1 << 2) :
        {
            int dimsArrayOfRes[2] = {iRows, sizeOfVector};
            types::Double* pDouble = new types::Double(2, dimsArrayOfRes);
            for (int i = 0; i < sizeOfVector; i++)
            {
                double* dbl = vIT[i]->getAs<types::Double>()->get();
                for (int j = 0; j < iRows; j++)
                {
                    pDouble->set(i * iRows + j, dbl[j]);
                }
            }
            out.push_back(pDouble);
        }
        break;
        default :
        {
            std::vector<types::InternalType*> vITTemp = std::vector<types::InternalType*>();
            vITTemp.push_back(vIT[0]);
            vIT[0] = nullptr;

            // sizeOfVector always > 1
            for (int i = 1; i < sizeOfVector; i++) // concatenates the Cells. ex : [String 4x1] [String 4x1] = [String 4x2]
            {
                types::GenericType* pGT = vITTemp.back()->getAs<types::GenericType>();
                if (pGT->getType() == vIT[i]->getType())
                {
                    int iCols = pGT->getCols();
                    int iTmpSize = pGT->getSize();
                    int iCurrentSize = vIT[i]->getAs<types::GenericType>()->getSize();
                    switch (pGT->getType())
                    {
                        case types::InternalType::ScilabString:
                        {
                            int arrayOfType[2] = {iRows, iCols + 1};
                            types::String* pType = new types::String(2, arrayOfType);
                            wchar_t** wcsTmp = pGT->getAs<types::String>()->get();
                            wchar_t** wcsCurrent = vIT[i]->getAs<types::String>()->get();
                            for (int k = 0; k < iTmpSize; k++)
                            {
                                pType->set(k, wcsTmp[k]);
                            }
                            for (int k = 0; k < iCurrentSize; k++)
                            {
                                pType->set(iRows * iCols + k, wcsCurrent[k]);
                            }
                            pGT->killMe();
                            vITTemp.pop_back();
                            vITTemp.push_back(pType);
                        }
                        break;
                        case types::InternalType::ScilabDouble :
                        {
                            int arrayOfType[2] = {iRows, iCols + 1};
                            types::Double* pType = new types::Double(2, arrayOfType);
                            double* pdType = pType->get();
                            double* pdTmp = pGT->getAs<types::Double>()->get();
                            double* pdCurrent = vIT[i]->getAs<types::Double>()->get();
                            memcpy(pdType, pdTmp, iTmpSize * sizeof(double));
                            memcpy(pdType + iTmpSize, pdCurrent, iCurrentSize * sizeof(double));
                            pGT->killMe();
                            vITTemp.pop_back();
                            vITTemp.push_back(pType);
                        }
                        break;
                        default: break;
                    }
                }
                else
                {
                    vITTemp.push_back(vIT[i]);
                    vIT[i] = nullptr;
                }
            }

            types::MList* pMList = new types::MList();
            pMList->append(new types::String(L"cblock"));
            for (auto& elem : vITTemp)
            {
                pMList->append(elem);
            }
            out.push_back(pMList);
        }
    }

    // cleanup temporary internal types
    for(auto& it : vIT)
    {
        if(it)
        {
            it->killMe();
        }
    }
}