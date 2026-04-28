#include "pcre2_private.h"
#include <pcre2.h>
#include "strsubst.h"
#include "os_string.h"
#include "Scierror.h"
#include "sci_malloc.h"
#include "localization.h"

pcre2_error_code pcre2_private(const wchar_t* INPUT_LINE, const wchar_t* INPUT_PAT,
                  int* Output_Start, int* Output_End,
                  wchar_t*** _pstCapturedString, int* _piCapturedStringCount,
                  wchar_t** formattedErrorMessage)
{
    int config = 0;
    pcre2_config(PCRE2_CONFIG_UNICODE, &config);
    if (config != 1)
    {
        return PCRE2_PRIV_UTF8_NOT_SUPPORTED;
    }

    int compile_opts = 0;
    size_t pat_len = 0;
    wchar_t* pat = pcre2_split_pattern(INPUT_PAT, &pat_len, &compile_opts, formattedErrorMessage);
    if (pat == NULL)
    {
        return PCRE2_PRIV_DELIMITER_NOT_ALPHANUMERIC;
    }

    int errcode = 0;
    PCRE2_SIZE erroff = 0;
    pcre2_code* re = pcre2_compile(pat, pat_len, compile_opts, &errcode, &erroff, NULL);
    if (!re)
    {
        if (formattedErrorMessage)
        {
            *formattedErrorMessage = MALLOC(sizeof(wchar_t) * PCRE2_PRIV_MAX_ERROR_MESSAGE_SIZE);
            pcre2_get_error_message(errcode, *formattedErrorMessage, PCRE2_PRIV_MAX_ERROR_MESSAGE_SIZE);
        }
        return PCRE2_PRIV_CAN_NOT_COMPILE_PATTERN;
    }

    pcre2_match_data* md = pcre2_match_data_create_from_pattern(re, NULL);
    if (md == NULL)
    {
        pcre2_code_free(re);
        return PCRE2_PRIV_NOT_ENOUGH_MEMORY_FOR_VECTOR;
    }

    size_t input_len = wcslen(INPUT_LINE);
    uint32_t match_opts = 0;
    int rc = pcre2_match(re, (PCRE2_SPTR)INPUT_LINE, PCRE2_ZERO_TERMINATED, 0, match_opts, md, NULL);

    if (rc == PCRE2_ERROR_NOMATCH)
    {
        pcre2_match_data_free(md);
        pcre2_code_free(re);
        return PCRE2_PRIV_NO_MATCH;
    }
    else if (rc < 0)
    {
        if (formattedErrorMessage)
        {
            *formattedErrorMessage = MALLOC(sizeof(wchar_t) * PCRE2_PRIV_MAX_ERROR_MESSAGE_SIZE);
            pcre2_get_error_message(errcode, *formattedErrorMessage, PCRE2_PRIV_MAX_ERROR_MESSAGE_SIZE);
        }
        pcre2_match_data_free(md);
        pcre2_code_free(re);
        return rc;
    }

    PCRE2_SIZE* ov = pcre2_get_ovector_pointer(md);
    *Output_Start = (int)ov[0];
    *Output_End = (int)ov[1];

    if (_pstCapturedString && _piCapturedStringCount)
    {
        uint32_t capcount = 0;
        pcre2_pattern_info(re, PCRE2_INFO_CAPTURECOUNT, &capcount);
        *_piCapturedStringCount = (int)capcount;

        if (_pstCapturedString && capcount > 0)
        {
            *_pstCapturedString = malloc(sizeof(wchar_t*) * capcount);
            for (uint32_t i = 0; i < capcount; ++i)
            {
                PCRE2_SIZE s = ov[2 * (i + 1)];
                PCRE2_SIZE e = ov[2 * (i + 1) + 1];
                size_t len = (s == PCRE2_UNSET || e == PCRE2_UNSET) ? 0 : (e - s);
                wchar_t* cap = malloc((len + 1) * sizeof(wchar_t));
                if (len > 0)
                {
                    wcsncpy(cap, INPUT_LINE + s, len);
                }

                cap[len] = L'\0';
                (*_pstCapturedString)[i] = cap;
            }
        }
    }

    pcre2_match_data_free(md);
    pcre2_code_free(re);
    return PCRE2_PRIV_FINISHED_OK;
}

void pcre2_error(const char* fname, int error, wchar_t* formattedErrorMessage)
{
    switch (error)
    {
        case PCRE2_PRIV_NO_MATCH:
            /*No match */
            break;
        case PCRE2_PRIV_NOT_ENOUGH_MEMORY_FOR_VECTOR:
            Scierror(999, _("%s: No more memory.\n"), fname);
            break;
        case PCRE2_PRIV_DELIMITER_NOT_ALPHANUMERIC:
        {
            const char* msg = _("%s: regexp pattern should be enclosed with \"/\".\n%ls%s");
            if (formattedErrorMessage)
            {
                Scierror(999, msg, fname, formattedErrorMessage, "\n");
                FREE(formattedErrorMessage);
            }
            else
            {
                Scierror(999, msg, fname, "", "");
            
            }
            break;
        }
        case PCRE2_PRIV_CAN_NOT_COMPILE_PATTERN:
        {
            const char* msg = _("%s: Can not compile regexp pattern.\n%ls%s");
            if (formattedErrorMessage)
            {
                Scierror(999, msg, fname, formattedErrorMessage, "\n");
                FREE(formattedErrorMessage);
            }
            else
            {
                Scierror(999, msg, fname, "", "");
            }
            break;
        }
        case PCRE2_PRIV_UTF8_NOT_SUPPORTED:
            Scierror(999, _("%s: Current PCRE2 library does not support UTF-8.\n"), fname);
            break;
        default:
            Scierror(999, _("%s: Unknown error.\n"), fname);
            break;
    }
}

wchar_t* pcre2_split_pattern(const wchar_t* pattern, size_t* pat_len, int* options, wchar_t** formattedErrorMessage)
{
    // cleared in case of error
    if (pat_len)
    {
        *pat_len = 0;
    }
    // will be used to check options validity
    int options_storage = 0;
    if (options)
    {
        *options = 0;
    }
    else
    {
        options = &options_storage;
    }
    // cleared in case of success
    if (formattedErrorMessage)
    {
        *formattedErrorMessage = NULL;
    }

    size_t pattern_len = wcslen(pattern);
    wchar_t* charOptions = pattern + pattern_len - 1;

    if (pattern_len < 2)
    {
        if (formattedErrorMessage)
        {
            *formattedErrorMessage = to_wide_string(_("pattern should start and end with /"));
        }
        return NULL;
    }

    // pattern[0] is used as the separator, it is documented as "/" however some Scilab internal code use '|' or '#'
    // ensure sed and Perl alternative delimiters works
    switch (pattern[0])
    {
        case L'/':
            break;
        case L'|':
            break;
        case L'#':
            break;
        case L'~':
            break;
        case L'_':
            break;
        case L'@':
            break;
        case L'=':
            break;
        case L'!':
            break;
        default:
            if (formattedErrorMessage)
            {
                *formattedErrorMessage = MALLOC(sizeof(wchar_t) * PCRE2_PRIV_MAX_ERROR_MESSAGE_SIZE);
                wchar_t* msg = to_wide_string(_("pattern should start with the / delimiter, not %c"));
                os_swprintf(*formattedErrorMessage, PCRE2_PRIV_MAX_ERROR_MESSAGE_SIZE, msg, pattern[0]);
                FREE(msg);
            }
            return NULL;
    }

    // Regex options are trailing flags
    *options = PCRE2_UTF;
    while (charOptions > pattern && *charOptions != pattern[0])
    {
        switch (*charOptions)
        {
        case L'g':
            // global: don't return after the first match
            // it is always set, the user can use only part of the matched string
            break;
        case L'i':
            *options |= PCRE2_CASELESS;
            break;
        case L'm':
            *options |= PCRE2_MULTILINE;
            break;
        case L's':
            *options |= PCRE2_DOTALL;
            break;
        case L'x':
            *options |= PCRE2_EXTENDED;
            break;
        case L'C':
            *options |= PCRE2_AUTO_CALLOUT;
            break;
        case L'J':
            *options |= PCRE2_DUPNAMES;
            break;
        case L'N':
            *options |= PCRE2_NO_AUTO_CAPTURE;
            break;
        case L'U':
            *options |= PCRE2_UNGREEDY;
            break;
        case L'A':
            *options |= PCRE2_ANCHORED;
            break;
        case L'D':
            *options |= PCRE2_DOLLAR_ENDONLY;
            break;
        case L'?':
            *options |= PCRE2_NO_UTF_CHECK;
            break;
        default:
            if (formattedErrorMessage)
            {
                *formattedErrorMessage = MALLOC(sizeof(wchar_t) * PCRE2_PRIV_MAX_ERROR_MESSAGE_SIZE);
                wchar_t* msg = to_wide_string(_("unable to parse regexp option '%c'."));
                os_swprintf(*formattedErrorMessage, PCRE2_PRIV_MAX_ERROR_MESSAGE_SIZE, msg, *charOptions);
                FREE(msg);
            }
            return NULL;
        }

        charOptions--;
    }
    if (pattern == charOptions)
    {
        if (formattedErrorMessage)
        {
            *formattedErrorMessage = to_wide_string(_("no trailing slash / found."));
        }
        return NULL;
    }

    // Getting the pattern without the delimiters and options.
    if (pat_len)
    {
        *pat_len = charOptions - pattern - 1;
    }
    wchar_t* pat = pattern + 1;

    return pat;
}
