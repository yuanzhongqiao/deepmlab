
/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) INRIA - Allan CORNET
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

/*--------------------------------------------------------------------------*/
#include "charEncoding.h"
#include "os_string.h"
#include "sci_malloc.h"
#include "strsubst.h"
#include "sciprint.h"
#include "core_math.h"
#include "pcre2_private.h"
#include <pcre2.h>

/*--------------------------------------------------------------------------*/
char *strsub(const char* input_string, const char* string_to_search, const char* replacement_string)
{
    const char *occurrence_str = NULL;
    char* result_str = NULL;
    char *replacedString = NULL;
    int count = 0, len = 0;

    if (input_string == NULL)
    {
        return NULL;
    }

    if (string_to_search == NULL || replacement_string == NULL)
    {
        return os_strdup(input_string);
    }

    occurrence_str = strstr (input_string, string_to_search);
    if (occurrence_str == NULL)
    {
        return os_strdup(input_string);
    }

    if (strlen (replacement_string) > strlen (string_to_search))
    {
        count = 0;
        len = (int)strlen (string_to_search);
        if (len)
        {
            occurrence_str = input_string;
            while (occurrence_str != NULL && *occurrence_str != '\0')
            {
                occurrence_str = strstr (occurrence_str, string_to_search);
                if (occurrence_str != NULL)
                {
                    occurrence_str += len;
                    count++;
                }
            }
        }
        len = count * ((int)strlen(replacement_string) - (int)strlen(string_to_search)) + (int)strlen(input_string);
    }
    else
    {
        len = (int)strlen(input_string);
    }

    replacedString = (char*)MALLOC (sizeof(char) * (len + 1));
    if (replacedString == NULL)
    {
        return NULL;
    }

    occurrence_str = input_string;
    result_str = replacedString;
    len = (int)strlen (string_to_search);
    while (*occurrence_str != '\0')
    {
        if (*occurrence_str == string_to_search[0] && strncmp (occurrence_str, string_to_search, len) == 0)
        {
            const char *N = NULL;
            N = replacement_string;
            while (*N != '\0')
            {
                *result_str++ = *N++;
            }
            occurrence_str += len;
        }
        else
        {
            *result_str++ = *occurrence_str++;
        }
    }
    *result_str = '\0';

    return replacedString;
}

wchar_t *wcssub(const wchar_t* _pwstInput, const wchar_t* _pwstSearch, const wchar_t* _pwstReplace)
{
    int i               = 0;
    int iOccurs         = 0;
    size_t iReplace     = 0;
    size_t iSearch      = 0;
    size_t iOffset      = 0;

    size_t* piStart     = NULL;

    const wchar_t* pwstPos  = NULL;
    wchar_t* pwstOutput     = NULL;

    if (_pwstInput == NULL)
    {
        return NULL;
    }

    if (_pwstSearch == NULL || _pwstReplace == NULL)
    {
        return os_wcsdup(_pwstInput);
    }

    //no needle
    if (_pwstSearch[0] == L'\0')
    {
        //no input
        if (_pwstInput[0] == L'\0')
        {
            return os_wcsdup(_pwstReplace);
        }
        else
        {
            return os_wcsdup(_pwstInput);
        }
    }

    //no input
    if (_pwstInput[0] == L'\0')
    {
        return os_wcsdup(_pwstInput);
    }

    iSearch     = wcslen(_pwstSearch);
    iReplace    = wcslen(_pwstReplace);
    piStart     = (size_t*)MALLOC(sizeof(size_t) * wcslen(_pwstInput));
    pwstPos     = _pwstInput;

    while (pwstPos)
    {
        pwstPos = wcsstr(pwstPos, _pwstSearch);
        if (pwstPos)
        {
            piStart[iOccurs++]  = pwstPos - _pwstInput;
            iOffset             += iReplace - iSearch;
            pwstPos             += iSearch;
        }
    }

    pwstOutput = (wchar_t*)MALLOC(sizeof(wchar_t) * (wcslen(_pwstInput) + iOffset + 1));
    memset(pwstOutput, 0x00, sizeof(wchar_t) * (wcslen(_pwstInput) + iOffset + 1));

    if (iOccurs == 0)
    {
        wcscpy(pwstOutput, _pwstInput);
    }
    else
    {
        for (i = 0 ; i < iOccurs ; i++)
        {
            if (i == 0)
            {
                //copy start of original string
                wcsncpy(pwstOutput, _pwstInput, piStart[i]);
            }
            else
            {
                //copy start of original string
                wcsncpy(pwstOutput + wcslen(pwstOutput), _pwstInput + piStart[i - 1] + iSearch, piStart[i] - (iSearch + piStart[i - 1]));
            }
            //copy replace string
            wcscpy(pwstOutput + wcslen(pwstOutput), _pwstReplace);
        }
        //copy end of original string
        wcscpy(pwstOutput + wcslen(pwstOutput), _pwstInput + piStart[iOccurs - 1] + iSearch);
    }

    FREE(piStart);
    return pwstOutput;
}
/*-------------------------------------------------------------------------------------*/
wchar_t** strsubst_reg(const wchar_t** _pwstInput, int _iInputSize, const wchar_t* _pwstSearch, const wchar_t* _pwstReplace, int* _piErr, wchar_t** formattedErrorMessage)
{
    wchar_t** pwstOutput = NULL;

    if (_pwstInput != NULL && _pwstSearch != NULL && _pwstReplace != NULL)
    {
        int i = 0;
        pwstOutput = (wchar_t**)CALLOC(_iInputSize, sizeof(wchar_t*));
        for (i = 0; i < _iInputSize; i++)
        {
            const wchar_t* pwst = _pwstInput[i];
            pwstOutput[i] = strsub_reg(pwst, _pwstSearch, _pwstReplace, _piErr, formattedErrorMessage);
            if (*_piErr != 0)
            {
                break;
            }
        }
    }
    return pwstOutput;
}

wchar_t* strsub_reg(const wchar_t* input_string, const wchar_t* string_to_search, const wchar_t* replacement_string, int* ierr, wchar_t** formattedErrorMessage)
{
    int config = 0;
    pcre2_config(PCRE2_CONFIG_UNICODE, &config);
    if (config != 1)
    {
        *ierr = PCRE2_PRIV_UTF8_NOT_SUPPORTED;
        return NULL;
    }

    PCRE2_SPTR subject = (PCRE2_SPTR)input_string;
    PCRE2_SPTR replacement = (PCRE2_SPTR)replacement_string;

    *formattedErrorMessage = NULL;
    int compile_opts = 0;
    size_t pat_len = 0;
    wchar_t* pat = pcre2_split_pattern(string_to_search, &pat_len, &compile_opts, formattedErrorMessage);
    if (*formattedErrorMessage != NULL)
    {
        *ierr = PCRE2_PRIV_DELIMITER_NOT_ALPHANUMERIC;
        return NULL;
    }

    int errornumber;
    PCRE2_SIZE erroroffset;
    // Compilation du pattern
    pcre2_code* re = pcre2_compile(pat, pat_len, compile_opts, &errornumber, &erroroffset, NULL);
    if (re == NULL)
    {
        // Erreur de compilation
        *ierr = PCRE2_PRIV_CAN_NOT_COMPILE_PATTERN;
        if (formattedErrorMessage)
        {
            *formattedErrorMessage = MALLOC(sizeof(wchar_t) * PCRE2_PRIV_MAX_ERROR_MESSAGE_SIZE);
            pcre2_get_error_message(errornumber, *formattedErrorMessage, PCRE2_PRIV_MAX_ERROR_MESSAGE_SIZE);
        }
        return NULL;
    }

    pcre2_match_data* match_data = pcre2_match_data_create_from_pattern(re, NULL);
    if (match_data == NULL)
    {
        pcre2_code_free(re);
        *ierr = PCRE2_PRIV_NOT_ENOUGH_MEMORY_FOR_VECTOR;
        return NULL;
    }

    PCRE2_UCHAR* result_buffer = NULL;
    PCRE2_SIZE result_len = 0;
    uint32_t opts = PCRE2_SUBSTITUTE_GLOBAL | PCRE2_SUBSTITUTE_EXTENDED | PCRE2_SUBSTITUTE_OVERFLOW_LENGTH;
    int rc = pcre2_substitute(re, subject, PCRE2_ZERO_TERMINATED, 0, opts, NULL, NULL, replacement, PCRE2_ZERO_TERMINATED, result_buffer, &result_len);

    result_buffer = (PCRE2_UCHAR*)MALLOC(sizeof(PCRE2_UCHAR) * result_len);

    opts = PCRE2_SUBSTITUTE_GLOBAL | PCRE2_SUBSTITUTE_EXTENDED;
    rc = pcre2_substitute(re, subject, PCRE2_ZERO_TERMINATED, 0, opts, NULL, NULL, replacement, PCRE2_ZERO_TERMINATED, result_buffer, &result_len);

    if (rc == PCRE2_ERROR_NOSUBSTRING)
    {
        // equivalent to PCRE2_ERROR_NOMATCH
        *ierr = 0;
        pcre2_match_data_free(match_data);
        pcre2_code_free(re);
        FREE(result_buffer);
        return os_wcsdup(input_string);
    }
    else if (rc < 0)
    {
        // errors from the internal call to pcre2_match() are passed straight back
        *ierr = PCRE2_PRIV_CAN_NOT_COMPILE_PATTERN;
        if (formattedErrorMessage)
        {
            *formattedErrorMessage = MALLOC(sizeof(wchar_t) * PCRE2_PRIV_MAX_ERROR_MESSAGE_SIZE);
            pcre2_get_error_message(rc, *formattedErrorMessage, PCRE2_PRIV_MAX_ERROR_MESSAGE_SIZE);
        }
        pcre2_match_data_free(match_data);
        pcre2_code_free(re);
        FREE(result_buffer);
        return NULL;
    }

    int len = (int)result_len + 1;
    wchar_t* ret = MALLOC(len * sizeof(wchar_t));
    memcpy(ret, result_buffer, result_len * sizeof(wchar_t));
    ret[result_len] = L'\0';
    
    pcre2_match_data_free(match_data);
    pcre2_code_free(re);
    FREE(result_buffer);

    *ierr = 0;
    return ret;
}
