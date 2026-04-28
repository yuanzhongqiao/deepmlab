/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2021 - 2023 - UTC - Stéphane MOTTELET
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include "function.hxx"
#include "double.hxx"
#include "string.hxx"
#include "odeparameters.hxx"

extern "C"
{
#include "localization.h"
#include "Scierror.h"
#include "sciprint.h"
}

void getBooleanInPlist(const char * _pstCaller, types::optional_list &opt, const wchar_t * _pwstLabel,
                      bool * _pbValue, bool _bDefaultValue)
{
    char errorMsg[256];
    types::InternalType *pI;
    if (opt.find(_pwstLabel) != opt.end())
    {
        pI = opt[_pwstLabel];
        if (pI->isBool() && pI->getAs<types::Bool>()->getSize() == 1)
        {
            *_pbValue = pI->getAs<types::Bool>()->get(0);
        }
        else
        {
            sprintf(errorMsg, _("%s: wrong value type for parameter \"%ls\": %s expected.\n"), _pstCaller, _pwstLabel, "boolean");
            throw ast::InternalError(errorMsg);
        }
    }
    else
    {
        *_pbValue = _bDefaultValue;
        return;
    }
    pI->DecreaseRef();
    pI->killMe();
    opt.erase(_pwstLabel);
}

void getDoubleInPlist(const char * _pstCaller, types::optional_list &opt, const wchar_t * _pwstLabel,
                      double * _pdblValue, double _dblDefaultValue, std::vector<double> checkValues)
{
    char errorMsg[256];
    types::InternalType *pI;
    if (opt.find(_pwstLabel) != opt.end())
    {
        pI = opt[_pwstLabel];
        if (pI->isDouble() && pI->getAs<types::Double>()->getSize() == 1 &&  pI->getAs<types::Double>()->isComplex() == false)
        {
            *_pdblValue = pI->getAs<types::Double>()->get(0);
        }
        else
        {
            sprintf(errorMsg, _("%s: wrong value type for parameter \"%ls\": %s expected.\n"), _pstCaller, _pwstLabel, "double");
            throw ast::InternalError(errorMsg);
        }
    }
    else
    {
        *_pdblValue = _dblDefaultValue;
        return;
    }
    if (checkValues.size() == 2)
    {
        /* bounds */
        if (*_pdblValue < checkValues[0])
        {
            sprintf(errorMsg, _("%s: wrong value %g for parameter \"%ls\": lower bound is %g.\n"), _pstCaller, *_pdblValue, _pwstLabel, checkValues[0]);
            throw ast::InternalError(errorMsg);
        }
        if (*_pdblValue > checkValues[1])
        {
            sprintf(errorMsg, _("%s: wrong value %g for parameter \"%ls\": upper bound is %g.\n"), _pstCaller, *_pdblValue, _pwstLabel, checkValues[1]);
            throw ast::InternalError(errorMsg);
        }
    }
    else if (checkValues.size() > 0)
    {
         if (std::find(checkValues.begin(), checkValues.end(), *_pdblValue) == checkValues.end())
         {
             std::sort(checkValues.begin(), checkValues.end());
             auto last = std::unique(checkValues.begin(), checkValues.end());
             std::ostringstream os;
             for (auto it = checkValues.begin(); it < last; it++)
             {
                 os << *it;
                 if (it < last-1)
                 {
                     os << ", ";
                 }
             }
             sprintf(errorMsg, _("%s: wrong value %g for parameter \"%ls\": must be in the set {%s}.\n"), _pstCaller, *_pdblValue, _pwstLabel,os.str().c_str());
             throw ast::InternalError(errorMsg);
         }
    }
    pI->DecreaseRef();
    pI->killMe();
    opt.erase(_pwstLabel);
}

void getIntVectorInPlist(const char * _pstCaller, types::optional_list &opt, const wchar_t * _pwstLabel,
                      std::vector<int> &intValues, std::vector<int>  defaultValues, std::vector<int> checkValues, std::vector<int> iSize)
{
    char errorMsg[256];
    types::InternalType *pI = NULL;
    types::Double *_pDblValue = NULL;
  
    if (opt.find(_pwstLabel) != opt.end())
    {
        pI = opt[_pwstLabel];
        if (pI->isDouble() &&  pI->getAs<types::Double>()->isComplex() == false)
        {
            _pDblValue  = pI->getAs<types::Double>();
            if (iSize.size() == 1)
            {
                if (_pDblValue->getSize() != iSize[0])
                {
                    sprintf(errorMsg, _("%s: wrong size for parameter \"%ls\": %d expected.\n"), _pstCaller, _pwstLabel, iSize[0]);
                    throw ast::InternalError(errorMsg);
                }
            }
            else if (iSize.size() == 2)
            {
                if (_pDblValue->getSize() < iSize[0] || _pDblValue->getSize() > iSize[1])
                {
                    sprintf(errorMsg, _("%s: wrong size for parameter \"%ls\": %d to %d expected.\n"), _pstCaller, _pwstLabel, iSize[0],iSize[1]);
                    throw ast::InternalError(errorMsg);
                }
            }
        }
        else
        {
            sprintf(errorMsg, _("%s: wrong value type for parameter \"%ls\": %s expected.\n"), _pstCaller, _pwstLabel, "double");
            throw ast::InternalError(errorMsg);
        }
    }
    else
    {
        intValues = defaultValues;
        return;
    }
    if (checkValues.size() == 2)
    {
        for (int i=0; i<_pDblValue->getSize(); i++)
        {
            if (_pDblValue->get(i) != std::floor(_pDblValue->get(i)))
            {
                sprintf(errorMsg, _("%s: wrong value for parameter \"%ls\": %s expected.\n"), _pstCaller, _pwstLabel, "integer");
                throw ast::InternalError(errorMsg);
            }
            if (_pDblValue->get(i) < checkValues[0])
            {
                sprintf(errorMsg, _("%s: wrong value %d in parameter \"%ls\": lower bound is %d.\n"), _pstCaller, (int)_pDblValue->get(i), _pwstLabel, checkValues[0]);
                throw ast::InternalError(errorMsg);
            }
            if (_pDblValue->get(i) > checkValues[1])
            {
                sprintf(errorMsg, _("%s: wrong value %d in parameter \"%ls\": upper bound is %d.\n"), _pstCaller, (int)_pDblValue->get(i), _pwstLabel, checkValues[1]);
                throw ast::InternalError(errorMsg);
            }
        }
    }
    for (int i=0; i<_pDblValue->getSize() ; i++)
    {
      intValues.push_back((int)_pDblValue->get(i));
    }
    pI->DecreaseRef();
    pI->killMe();
    opt.erase(_pwstLabel);
}

void getDoubleVectorInPlist(const char * _pstCaller, types::optional_list &opt, const wchar_t * _pwstLabel,
                      std::vector<double> &dblValues, std::vector<double>  defaultValues, std::vector<double> checkValues, int iSize)
{
    char errorMsg[256];
    types::InternalType *pI = NULL;
    types::Double *_pDblValue = NULL;
    if (opt.find(_pwstLabel) != opt.end())
    {
        pI = opt[_pwstLabel];
        if (pI->isDouble() &&  pI->getAs<types::Double>()->isComplex() == false)
        {
             _pDblValue  = pI->getAs<types::Double>();
             if (_pDblValue->getSize() != iSize && _pDblValue->getSize() != 1)
             {
                 sprintf(errorMsg, _("%s: wrong size for parameter \"%ls\": %d or 1 expected.\n"), _pstCaller, _pwstLabel, iSize);
                 throw ast::InternalError(errorMsg);
             }
        }
        else
        {
            sprintf(errorMsg, _("%s: wrong value type for parameter \"%ls\": %s expected.\n"), _pstCaller, _pwstLabel, "double");
            throw ast::InternalError(errorMsg);
        }
    }
    else
    {
        dblValues = defaultValues;
        if (dblValues.size() == 1)
        {
            dblValues.resize(iSize);
            fill(dblValues.begin(),dblValues.end(),dblValues[0]);
        }
        return;
    }
    if (checkValues.size() == 2)
    {
        for (int i=0; i<_pDblValue->getSize(); i++)
        {
            if (_pDblValue->get(i) < checkValues[0])
            {
                sprintf(errorMsg, _("%s: wrong value %g in parameter \"%ls\": lower bound is %g.\n"), _pstCaller, _pDblValue->get(i), _pwstLabel, checkValues[0]);
                throw ast::InternalError(errorMsg);
            }
            if (_pDblValue->get(i) > checkValues[1])
            {
                sprintf(errorMsg, _("%s: wrong value %g in parameter \"%ls\": upper bound is %g.\n"), _pstCaller, _pDblValue->get(i), _pwstLabel, checkValues[1]);
                throw ast::InternalError(errorMsg);
            }
        }
    }
    dblValues.resize(iSize);
    if (_pDblValue->getSize() == 1)
    {
        fill(dblValues.begin(),dblValues.end(),_pDblValue->get(0));
    }
    else
    {
        for (int i=0; i<iSize; i++)
        {
          dblValues[i] = _pDblValue->get(i);
        }
    }
    pI->DecreaseRef();
    pI->killMe();
    opt.erase(_pwstLabel);
}



void getIntInPlist(const char * _pstCaller, types::optional_list &opt, const wchar_t * _pwstLabel,
                   int * _piValue, int _iDefaultValue, std::vector<int> checkValues)
{
    char errorMsg[256];
    types::InternalType *pI = NULL;
    if (opt.find(_pwstLabel) != opt.end())
    {
        pI = opt[_pwstLabel];
        if (pI->isDouble() && pI->getAs<types::Double>()->getSize() == 1 &&  pI->getAs<types::Double>()->isComplex() == false)
        {
            double dblValue = pI->getAs<types::Double>()->get(0);
            *_piValue = (int) dblValue;
            if ((double)(*_piValue) != dblValue)
            {
                sprintf(errorMsg, _("%s: wrong value for parameter \"%ls\": %s expected.\n"), _pstCaller, _pwstLabel, "integer");
                throw ast::InternalError(errorMsg);
            }
        }
        else
        {
            sprintf(errorMsg, _("%s: wrong value type for parameter \"%ls\": %s expected.\n"), _pstCaller, _pwstLabel, "double");
            throw ast::InternalError(errorMsg);
        }
    }
    else
    {
        *_piValue = _iDefaultValue;
        return;
    }
    
    if (checkValues.size() == 2)
    {
        /* bounds */
        if (*_piValue < checkValues[0])
        {
            sprintf(errorMsg, _("%s: wrong value %d for parameter \"%ls\": lower bound is %d.\n"), _pstCaller, *_piValue, _pwstLabel, checkValues[0]);
            throw ast::InternalError(errorMsg);
        }
        if (*_piValue > checkValues[1])
        {
            sprintf(errorMsg, _("%s: wrong value %d for parameter \"%ls\": upper bound is %d.\n"), _pstCaller, *_piValue, _pwstLabel, checkValues[1]);
            throw ast::InternalError(errorMsg);
        }
    }
    else if (checkValues.size() > 0)
    {
         if (std::find(checkValues.begin(), checkValues.end(), *_piValue) == checkValues.end())
         {
             std::sort(checkValues.begin(), checkValues.end());
             auto last = std::unique(checkValues.begin(), checkValues.end());
             std::ostringstream os;
             for (auto it = checkValues.begin(); it < last; it++)
             {
                 os << *it;
                 if (it < last-1)
                 {
                     os << ", ";
                 }
             }
             sprintf(errorMsg, _("%s: wrong value %d for parameter \"%ls\": must be in the set {%s}.\n"), _pstCaller, *_piValue, _pwstLabel,os.str().c_str());
             throw ast::InternalError(errorMsg);
         }
    }
    pI->DecreaseRef();
    pI->killMe();
    opt.erase(_pwstLabel);
}

void getStringInPlist(const char * _pstCaller, types::optional_list &opt, const wchar_t * _pwstLabel, std::wstring & stValue,
                        std::wstring stDefaultValue, std::vector<std::wstring> checkValues)
{
    char errorMsg[2048];
    types::InternalType *pI = NULL;

    if (opt.find(_pwstLabel) != opt.end())
    {
        pI = opt[_pwstLabel];
        if (pI->isString())
        {
            stValue.assign(pI->getAs<types::String>()->get(0));
        }
        else
        {
            sprintf(errorMsg, _("%s: wrong value type for parameter \"%ls\": %s expected.\n"), _pstCaller, _pwstLabel, "string");
            throw ast::InternalError(errorMsg);
        }
    }
    else
    {
        stValue = stDefaultValue;
        return;
    }

    if (std::find(checkValues.begin(), checkValues.end(), stValue) == checkValues.end())
    {
        std::wstringstream os;
        for (auto it = checkValues.begin(); it < checkValues.end(); it++)
        {
            os << L"\"" << *it << L"\"";
            if (it < checkValues.end()-1)
            {
                os << L", ";
            }
        }
        sprintf(errorMsg, _("%s: wrong value \"%ls\" for parameter \"%ls\": must be in the set {%ls}.\n"), _pstCaller, stValue.c_str(), _pwstLabel,os.str().c_str());
        throw ast::InternalError(errorMsg);
    }
    pI->DecreaseRef();
    pI->killMe();
    opt.erase(_pwstLabel);
}
