/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *
 * Copyright (C) 2012 - 2016 - Scilab Enterprises
 *  Copyright (C) 2017 - ESI-Group - Cedric DELAMARRE
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#ifndef __WEBTOOLS_GW_HXX__
#define __WEBTOOLS_GW_HXX__

#include "cpp_gateway_prototype.hxx"
#include "function.hxx"

extern "C"
{
#include "dynlib_webtools_gw.h"
}

class WebtoolsModule
{
private :
    WebtoolsModule() {};
    ~WebtoolsModule() {};
public :
    WEBTOOLS_GW_IMPEXP static int Load();
    WEBTOOLS_GW_IMPEXP static int Unload()
    {
        return 1;
    }
};

CPP_OPT_GATEWAY_PROTOTYPE_EXPORT(sci_http_get, WEBTOOLS_GW_IMPEXP);
CPP_OPT_GATEWAY_PROTOTYPE_EXPORT(sci_http_post, WEBTOOLS_GW_IMPEXP);
CPP_OPT_GATEWAY_PROTOTYPE_EXPORT(sci_http_put, WEBTOOLS_GW_IMPEXP);
CPP_OPT_GATEWAY_PROTOTYPE_EXPORT(sci_http_patch, WEBTOOLS_GW_IMPEXP);
CPP_OPT_GATEWAY_PROTOTYPE_EXPORT(sci_http_delete, WEBTOOLS_GW_IMPEXP);
CPP_OPT_GATEWAY_PROTOTYPE_EXPORT(sci_http_upload, WEBTOOLS_GW_IMPEXP);
CPP_OPT_GATEWAY_PROTOTYPE_EXPORT(sci_toJSON, WEBTOOLS_GW_IMPEXP);
CPP_OPT_GATEWAY_PROTOTYPE_EXPORT(sci_fromJSON, WEBTOOLS_GW_IMPEXP);
CPP_GATEWAY_PROTOTYPE_EXPORT(sci_url_encode, WEBTOOLS_GW_IMPEXP);
CPP_GATEWAY_PROTOTYPE_EXPORT(sci_url_decode, WEBTOOLS_GW_IMPEXP);
CPP_GATEWAY_PROTOTYPE_EXPORT(sci_url_split, WEBTOOLS_GW_IMPEXP);

types::Function::ReturnValue sci_http_put_post(types::typed_list& in, types::optional_list& opt, int _iRetCount, types::typed_list& out, const char* fname);

#endif /* !__WEBTOOLS_GW_HXX__ */
