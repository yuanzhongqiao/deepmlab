/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2006 - INRIA - Fabrice Leray
 * Copyright (C) 2006 - INRIA - Jean-Baptiste Silvy
 * Copyright (C) 2011 - DIGITEO - Bruno JOFRET
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

/*------------------------------------------------------------------------*/
/* file: sci_glue.h                                                       */
/* desc : interface for glue routine                                      */
/*------------------------------------------------------------------------*/

#include <string.h>
#include <stdlib.h>

#include "graphics_gw.hxx"
#include "function.hxx"
#include "graphichandle.hxx"

extern "C"
{
#include "HandleManagement.h"
#include "createGraphicObject.h"
#include "getGraphicObjectProperty.h"
#include "graphicObjectProperties.h"

#include "Scierror.h"
#include "localization.h"
}

const char fname[] = "glue";
    /*--------------------------------------------------------------------------*/
types::Function::ReturnValue sci_glue(types::typed_list& in, int _iRetCount, types::typed_list& out)
{
    if (in.size() != 1)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d expected.\n"), fname, 1);
        return types::Function::Error;
    }

    if (_iRetCount > 1)
    {
        Scierror(78, _("%s: Wrong number of output argument(s): %d expected.\n"), fname, 1);
        return types::Function::Error;
    }

    if (in[0]->getType() != types::InternalType::ScilabHandle)
    {
        Scierror(202, _("%s: Wrong type for input argument #%d: Handle matrix expected.\n"), fname, 1);
        return types::Function::Error;
    }

    types::GraphicHandle* gh = in[0]->getAs<types::GraphicHandle>();
    long long* h = gh->get();
    int s = gh->getSize();

    //check unique
    std::vector<long long> v(h, h + s);

    std::sort(v.begin(), v.end());
    auto last = std::unique(v.begin(), v.end());

    if (last != v.end())
    {
        Scierror(999, _("%s: Each handle should not appear twice.\n"), "glue");
        return types::Function::Error;
    }

    //create compound and check has same parent
    int iParentUID = -1;
    std::vector<int> obj(s);
    for (int i = 0; i < s; i++)
    {
        int iObjUID = getObjectFromHandle((long)h[i]);
        obj[i] = iObjUID;
        if (iObjUID == 0)
        {
            Scierror(999, _("%s: The handle is not or no more valid.\n"), fname);
            return types::Function::Error;
        }

        int type = 0;
        int* piType = &type;
        getGraphicObjectProperty(iObjUID, __GO_TYPE__, jni_int, (void**)&piType);
        switch (type)
        {
            case __GO_MATPLOT__:
            case __GO_CHAMP__:
            case __GO_FEC__:
            case __GO_GRAYPLOT__:
            case __GO_POLYLINE__:
            case __GO_FAC3D__:
            case __GO_PLOT3D__:
            case __GO_ARC__:
            case __GO_RECTANGLE__:
            case __GO_SEGS__:
            case __GO_TEXT__:
            case __GO_COMPOUND__:
                break;
            default:
                Scierror(999, _("%s: Wrong type of handle, \"%s\" are not managed.\n"), fname, getHandleTypeStr(type));
                return types::Function::Error;
        }

        int iCurrentParentUID = getParentObject(iObjUID);
        if (i == 0)
        {
            iParentUID = iCurrentParentUID;
        }

        if (iParentUID != iCurrentParentUID)
        {
            Scierror(999, _("%s: Objects must have the same parent.\n"), fname);
            return types::Function::Error;
        }
    }

    int iCompoundUID = createCompound(iParentUID, obj.data(), s);
    setCurrentObject(iCompoundUID);

    out.push_back(new types::GraphicHandle(getHandle(iCompoundUID)));
    return types::Function::OK;
}
/*--------------------------------------------------------------------------*/
