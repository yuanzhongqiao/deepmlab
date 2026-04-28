/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include "getUIStyle.h"
#include "HandleManagement.h"
#include "getGraphicObjectProperty.h"
#include "graphicObjectProperties.h"

int getUIStyle(long h)
{
    int h2 = getObjectFromHandle(h);

    int style = 0;
    int* piStyle = &style;
    getGraphicObjectProperty(h2, __GO_STYLE__, jni_int, (void**)&piStyle);
    return style;
}