/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2010-2011 - DIGITEO - Allan CORNET
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
#include <string.h>
#include <ctype.h>
#include "csvDefault.h"
#include "sci_malloc.h"
#include "os_string.h"
#include "fprintfMat.h"
#include "checkCsvWriteFormat.h"
// =============================================================================
static char *replaceInFormat(const char *format);
// =============================================================================
int checkCsvWriteFormat(const char *format)
{
    if (format)
    {
        char *tokenPercent1 = strchr((char*)format, '%');
        char *tokenPercent2 = strrchr((char*)format, '%');
        if ((tokenPercent2 && tokenPercent1) && (tokenPercent1 == tokenPercent2))
        {
            char *cleanedFormat = fprintfMat_getCleanedFormat(format);
            if (cleanedFormat)
            {
                FREE(cleanedFormat);
                cleanedFormat = NULL;
                return 0;
            }
        }
    }
    return 1;
}
// =============================================================================
static char *replaceInFormat(const char *format)
{
    if (format)
    {
        char *cleanedFormat = fprintfMat_getCleanedFormat(format);
        if (cleanedFormat)
        {
            FREE(cleanedFormat);
            cleanedFormat = NULL;
            return os_strdup("%s");
        }
    }

    return NULL;
}
// =============================================================================
