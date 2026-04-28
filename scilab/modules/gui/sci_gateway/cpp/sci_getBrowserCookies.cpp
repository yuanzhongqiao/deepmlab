/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include "CallScilabBridge.hxx"
#include "function.hxx"
#include "graphichandle.hxx"
#include "gui_gw.hxx"
#include "string.hxx"
#include "double.hxx"
#include "json.hxx"


extern "C"
{
#include "HandleManagement.h"
#include "Scierror.h"
#include "Sciwarning.h"
#include "getGraphicObjectProperty.h"
#include "getScilabJavaVM.h"
#include "graphicObjectProperties.h"
#include "sciprint.h"
}

static const std::string funname = "getBrowserCookies";

types::Function::ReturnValue sci_getBrowserCookies(types::typed_list& in, int _iRetCount, types::typed_list& out)
{
    if (in.size() != 1)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d expected.\n"), funname.data(), 1);
        return types::Function::Error;
    }

    if (in[0]->isHandle() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: A handle expected.\n"), funname.data(), 1);
        return types::Function::Error;
    }

    types::GraphicHandle* h = in[0]->getAs<types::GraphicHandle>();

    int iVal = -1;
    int* piVal = &iVal;

    int handle = getObjectFromHandle((long)h->get()[0]);
    getGraphicObjectProperty(handle, __GO_TYPE__, jni_int, (void**)&piVal);
    if (iVal != __GO_UICONTROL__)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: An uicontrol expected.\n"), funname.data(), 1);
        return types::Function::Error;
    }

    getGraphicObjectProperty(handle, __GO_STYLE__, jni_int, (void**)&piVal);
    if (iVal != __GO_UI_BROWSER__)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: A browser uicontrol expected.\n"), funname.data(), 1);
        return types::Function::Error;
    }

    char* json = org_scilab_modules_gui_bridge::CallScilabBridge::getBrowserCookies(getScilabJavaVM(), handle);
    if (json == nullptr || strlen(json) == 0)
    {
        out.push_back(types::Double::Empty());
        return types::Function::OK;
    }

    out.push_back(fromJSON(json));
    return types::Function::OK;
}
