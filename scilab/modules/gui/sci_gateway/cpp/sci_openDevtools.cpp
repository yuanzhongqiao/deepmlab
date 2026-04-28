/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include "gui_gw.hxx"
#include "function.hxx"
#include "graphichandle.hxx"
#include "CallScilabBridge.hxx"

extern "C"
{
#include "getGraphicObjectProperty.h"
#include "graphicObjectProperties.h"
#include "HandleManagement.h"
#include "getScilabJavaVM.h"
#include "Scierror.h"
#include "sciprint.h"
#include "Sciwarning.h"
}

static const std::string funname = "openDevtools";

types::Function::ReturnValue sci_openDevtools(types::typed_list& in, int _iRetCount, types::typed_list& /*out*/)
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


    getGraphicObjectProperty(handle, __GO_UI_DEBUG__, jni_bool, (void**)&piVal);
    if (iVal == 1)
    {
        org_scilab_modules_gui_bridge::CallScilabBridge::browserDebug(getScilabJavaVM(), handle);
    }
    else
    {
        Sciwarning(_("%s: WARNING: The browser uicontrol is not in debug mode.\n"), funname.data());
    }

    return types::Function::OK;
}
