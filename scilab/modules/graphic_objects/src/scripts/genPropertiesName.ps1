<# Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
## Copyright (C) 2022 - Dassault Systèmes S.E. - Clément DAVID
##
## This file is hereby licensed under the terms of the GNU GPL v2.0,
## pursuant to article 5.3.4 of the CeCILL v.2.1.
## This file was originally licensed under the terms of the CeCILL v2.1,
## and continues to be available under such terms.
## For more information, see the COPYING file which you should have received
## along with this program.
#>

<#
    .SYNOPSIS
    Update C and Java files from the propertiesMap.properties file
#>

$PropertiesFile = "$PSScriptRoot/propertiesMap.properties"
$CFile = "$PSScriptRoot/../../includes/graphicObjectProperties.h"
$JavaFile = "$PSScriptRoot/../../src/java/org/scilab/modules/graphic_objects/graphicObject/GraphicObjectProperties.java"


function Generate-Header {
    param (
        $OutFile
    )
    
    "/*" > $OutFile
    " *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab" >> $OutFile
    " *  Copyright (C) 2010-2012 - DIGITEO - Bruno JOFRET" >> $OutFile
    " *  Copyright (C) 2012-2014 - Scilab-Enterprises - Bruno JOFRET" >> $OutFile
    " *" >> $OutFile
    " *  This source file is licensed as described in the file COPYING, which" >> $OutFile
    " *  you should have received as part of this distribution.  The terms" >> $OutFile
    " *  are also available at" >> $OutFile
    " *  https://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt" >> $OutFile
    " *" >> $OutFile
    " */" >> $OutFile
    ""  >> $OutFile
    "/*" >> $OutFile
    " * -=- This is a generated file, please do not edit by hand             -=-" >> $OutFile
    " * -=- Please see properties definitions in                             -=-" >> $OutFile
    " * -=- SCI/modules/graphic_objects/src/scripts/propertiesMap.properties -=-" >> $OutFile
    " */" >> $OutFile
    "" >> $OutFile
}

function Generate-C {
    param (
        $OutFile,
        $PropertiesFile
    )

    echo "-- Building GraphicObjectProperties.h --"
    Remove-Item $OutFile
    Generate-Header $OutFile
    "#ifndef  __GRAPHIC_OBJECT_PROPERTIES_H__" >> $OutFile
    "#define __GRAPHIC_OBJECT_PROPERTIES_H__" >> $OutFile
    ""  >> $OutFile

    $num = 0
    Get-Content $PropertiesFile | where {$_ -ne ""} | ForEach-Object {
        "#define {0} {1:n0}" -f $_, $num >> $OutFile
        $num++
    }
    
    ""  >> $OutFile
    "#endif /* !__GRAPHIC_OBJECT_PROPERTIES_H__ */" >> $OutFile
}

function Generate-Java {
    param (
        $OutFile,
        $PropertiesFile
    )

    echo "-- Building GraphicObjectProperties.java --"
    Remove-Item $OutFile
    Generate-Header $OutFile
    "package org.scilab.modules.graphic_objects.graphicObject;" >> $OutFile
    ""  >> $OutFile
    "public class GraphicObjectProperties {" >> $OutFile
    ""  >> $OutFile

    $num = 0
    Get-Content $PropertiesFile | where {$_ -ne ""} | ForEach-Object {
        "    public static final int {0} = {1:n0};" -f $_, $num >> $OutFile
        $num++
    }

    ""  >> $OutFile
    "}"  >> $OutFile
}

Generate-C $CFile $PropertiesFile
Generate-Java $JavaFile $PropertiesFile
