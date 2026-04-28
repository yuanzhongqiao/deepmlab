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
#include "SetUicontrol.h"
}

int SetUicontrolDebug(void* _pvCtx, int iObjUID, void* _pvData, int valueType, int nbRow, int nbCol)
{
    int type = -1;
    int* piType = &type;

    // Check type
    getGraphicObjectProperty(iObjUID, __GO_TYPE__, jni_int, (void**)&piType);
    if ((type != __GO_UICONTROL__))
    {
        Scierror(999, _("'%s' property does not exist for this handle.\n"), "Debug");
        return SET_PROPERTY_ERROR;
    }

    getGraphicObjectProperty(iObjUID, __GO_STYLE__, jni_int, (void**)&piType);
    if ((type != __GO_UI_BROWSER__))
    {
        Scierror(999, _("'%s' property does not exist for this handle.\n"), "Debug");
        return SET_PROPERTY_ERROR;
    }

    int b = (int)FALSE;
    BOOL status = FALSE;

    b = tryGetBooleanValueFromStack(_pvData, valueType, nbRow, nbCol, "Debug");

    if (b == NOT_A_BOOLEAN_VALUE)
    {
        return SET_PROPERTY_ERROR;
    }

    status = setGraphicObjectProperty(iObjUID, __GO_UI_DEBUG__, &b, jni_bool, 1);

    if (status == TRUE)
    {
        return SET_PROPERTY_SUCCEED;
    }
    else
    {
        Scierror(999, _("'%s' property does not exist for this handle.\n"), "Enable");

        return SET_PROPERTY_ERROR;
    }
}
