/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

extern "C"
{
#include "GetUicontrol.h"
}

void* GetUicontrolDebug(void* _pvCtx, int iObjUID)
{
    int debug = 0;
    int* piDebug = &debug;

    getGraphicObjectProperty(iObjUID, __GO_UI_DEBUG__, jni_bool, (void**)&piDebug);

    if (piDebug == NULL)
    {
        Scierror(999, _("'%s' property does not exist for this handle.\n"), "Debug");
        return NULL;
    }

    if (debug == TRUE)
    {
        return sciReturnString("on");
    }
    else
    {
        return sciReturnString("off");
    }
}
