
/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 * 
 */

/*------------------------------------------------------------------------*/
#ifndef __PCRE2_PRIVATE_H__
#define __PCRE2_PRIVATE_H__

#include "charEncoding.h"
#include "dynlib_string.h"

typedef enum
{
    PCRE2_PRIV_FINISHED_OK = 0,
    PCRE2_PRIV_NO_MATCH = -1, // might not be an hard-error, depending on the context
    PCRE2_PRIV_NOT_ENOUGH_MEMORY_FOR_VECTOR = -2,
    PCRE2_PRIV_DELIMITER_NOT_ALPHANUMERIC = -3, // reported by pcre2_split_pattern
    PCRE2_PRIV_CAN_NOT_COMPILE_PATTERN = -4,
    PCRE2_PRIV_UTF8_NOT_SUPPORTED = -5
} pcre2_error_code;

// The allocated size for the formatted error message
#define PCRE2_PRIV_MAX_ERROR_MESSAGE_SIZE 256

// call PCRE2 with a line and pattern
STRING_IMPEXP pcre2_error_code pcre2_private(const wchar_t* INPUT_LINE, const wchar_t* INPUT_PAT, int* Output_Start, int* Output_End, wchar_t*** _pstCapturedString, int* _piCapturedStringCount, wchar_t** formattedErrorMessage);

// call Scierror() with the function name, the error code and the pcre2 formattedErrorMessage
STRING_IMPEXP void pcre2_error(const char* fname, int error, wchar_t* formattedErrorMessage);

// Check pattern and decode options to be passed to PCRE2
//
// return start of the pattern or NULL on invalid pattern
// [out, optional] output length of the pattern (excluding delimiters and options)
// [out, optional] options PCRE2 flag
// [out, optional] allocated formattedErrorMessage error message in case of invalid pattern
STRING_IMPEXP wchar_t* pcre2_split_pattern(const wchar_t* input_string, size_t* pattern_length, int* options, wchar_t** formattedErrorMessage);

// The linked PCRE2 library should have wchar_t size
#ifdef _MSC_VER
#define PCRE2_CODE_UNIT_WIDTH 16
#else
#define PCRE2_CODE_UNIT_WIDTH 32
#endif

#endif /* !__PCRE2_PRIVATE_H__ */
