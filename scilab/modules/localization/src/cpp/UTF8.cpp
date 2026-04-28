/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2008 - Yung-Jang Lee
 * Copyright (C) 2009 - DIGITEO - Antoine ELIAS , Allan CORNET
 * Copyright (C) 2015 - Scilab Enterprises - Calixte DENIZET
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

#include "UTF8.hxx"
extern "C"
{
#include "charEncoding.h"
#include "sci_malloc.h"
}

namespace scilab
{

std::string UTF8::toUTF8(const std::wstring & wstr)
{
    if (wstr.empty())
    {
        return std::string();
    }

    char* buf = wide_string_to_UTF8(wstr.data());
    if (buf == nullptr)
    {
        return std::string();
    }

    std::string ret(buf);
    FREE(buf);
    return ret;
}

std::wstring UTF8::toWide(const std::string & str)
{
    if (str.empty())
    {
        return std::wstring();
    }

    wchar_t* buf = to_wide_string(str.data());
    if (buf == nullptr)
    {
        return std::wstring();
    }


    std::wstring ret(buf);
    FREE(buf);
    return ret;
}
} // namespace scilab
