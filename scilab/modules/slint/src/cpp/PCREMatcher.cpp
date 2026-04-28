/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2015 - Scilab Enterprises - Calixte DENIZET
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

#include "PCREMatcher.hxx"
#include "UTF8.hxx"

extern "C"
{
#include "sci_malloc.h"
#include "charEncoding.h"
}

namespace slint
{

PCREMatcher::PCREMatcher(const std::wstring & _pattern) : pattern(_pattern)
{
    if (_pattern.empty())
    {
        re = nullptr;
    }
    else
    {
        int errorcode;
        PCRE2_SIZE errorOffset;
        uint32_t options = PCRE2_UTF;
        re = pcre2_compile((PCRE2_SPTR)pattern.c_str(), PCRE2_ZERO_TERMINATED, options, &errorcode, &errorOffset, nullptr);
        if (!re)
        {
            PCRE2_UCHAR buffer[256];
            pcre2_get_error_message(errorcode, buffer, sizeof(buffer));

            throw PCREException(pattern, (char*)buffer, errorOffset);
        }
    }
}

PCREMatcher::~PCREMatcher()
{
    if (re)
    {
        pcre2_code_free(re);
    }
}

bool PCREMatcher::match(const std::wstring & str, const bool full) const
{
    if (!pattern.empty())
    {
        return match(str.c_str(), str.size(), full);
    }
    return true;
}

bool PCREMatcher::match(const wchar_t * str, const bool full) const
{
    return match(str, wcslen(str), full);
}

bool PCREMatcher::match(const wchar_t * str, const unsigned int len, const bool full) const
{
    if (!pattern.empty())
    {
        int resVect[3] = {0};
        char * _str = wide_string_to_UTF8(str);
        pcre2_match_data* match_data = pcre2_match_data_create_from_pattern(re, NULL);
        int result = pcre2_match(re, (PCRE2_SPTR)_str, len, 0, 0, match_data, NULL);
        FREE(_str);
        if (full)
        {
            // FIXME: dead code? resVect is not used by pcre2_match
            if (result == 1 && resVect[0] == 0 && resVect[1] == len)
            {
                return true;
            }
        }
        else
        {
            return result == 1;
        }

        return false;
    }
    return true;
}

const std::wstring & PCREMatcher::getPattern() const
{
    return pattern;
}

} // namespace slint
