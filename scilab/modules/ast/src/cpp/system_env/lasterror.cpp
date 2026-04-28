/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2010 - DIGITEO - Antoine ELIAS
 *
 * Copyright (C) 2012 - 2016 - Scilab Enterprises
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include <algorithm>
#include "configvariable.hxx"
extern "C"
{
#include "lasterror.h"
}


int getLastErrorNumber(void)
{
    return ConfigVariable::getLastErrorNumber();
}
/*--------------------------------------------------------------------------*/
wchar_t *getLastErrorMessage(void)
{
    return const_cast<wchar_t*>(ConfigVariable::getLastErrorMessage().c_str());
}
/*--------------------------------------------------------------------------*/
void setLastErrorNumber(int _iError)
{
    ConfigVariable::setLastErrorNumber(_iError);
    ConfigVariable::setError();
}
/*--------------------------------------------------------------------------*/
void setLastErrorMessage(const wchar_t* _pwstError)
{
    if (_pwstError == NULL)
    {
        std::wstring wstError(L"");
        ConfigVariable::setLastErrorMessage(wstError);
    }
    else
    {
        std::wstring wstError(_pwstError);
        ConfigVariable::setLastErrorMessage(wstError);
    }
}
/*--------------------------------------------------------------------------*/
void setLastError(int _iError, const wchar_t* _pwstError)
{
    setLastErrorNumber(_iError);
    setLastErrorMessage(_pwstError);
}

/*--------------------------------------------------------------------------*/
void SetError()
{
    ConfigVariable::setError();
}
/*--------------------------------------------------------------------------*/
int isError()
{
    return ConfigVariable::isError() ? 1 : 0;
}
/*--------------------------------------------------------------------------*/
void resetError()
{
    ConfigVariable::resetError();
}
