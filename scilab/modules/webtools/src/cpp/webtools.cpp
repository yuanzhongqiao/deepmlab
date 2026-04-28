/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
* Copyright (C) 2017 - ESI-Group - Cedric DELAMARRE
*
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
#include <curl/curl.h>
extern "C"
{
    #include "webtools.h"
}

// functions call at library loading
int Initialize_Webtools(void)
{
    curl_global_init(CURL_GLOBAL_ALL);
    return 0;
}

// functions call at library closing
int Finalize_Webtools(void)
{
    curl_global_cleanup();
    return 0;
}
