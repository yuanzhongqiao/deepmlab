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
#include <Windows.h>
#include "buildMainWindowTitle_Windows.h"
#include "sci_malloc.h"
#include "getversion.h"
#include "WndThread.h"
/*--------------------------------------------------------------------------*/
char *buildMainWindowTitle_Windows(void)
{
    char *title = NULL;
    char *scilabVersionString = getScilabVersionAsString();

    title = (char*)MALLOC(sizeof(char) * (strlen("%s (%d)") + strlen(scilabVersionString) + 10 + 1));
    if (title)
    {
        wsprintf(title, "%s (%d)", scilabVersionString, getCurrentScilabId());
    }

    free(scilabVersionString);

    return title;
}
/*--------------------------------------------------------------------------*/
