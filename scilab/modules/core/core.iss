;
; Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
; Copyright (C) INRIA - Allan CORNET
; Copyright (C) DIGITEO - 2010 - Allan CORNET
;
; Copyright (C) 2012 - 2016 - Scilab Enterprises
;
; This file is hereby licensed under the terms of the GNU GPL v2.0,
; pursuant to article 5.3.4 of the CeCILL v.2.1.
; This file was originally licensed under the terms of the CeCILL v2.1,
; and continues to be available under such terms.
; For more information, see the COPYING file which you should have received
; along with this program.
;
;--------------------------------------------------------------------------------------------------------------
; Inno Setup Script (5.3 and more) for Scilab (UNICODE version required)
;
;--------------------------------------------------------------------------------------------------------------
; core module
;--------------------------------------------------------------------------------------------------------------
;
#define CORE "core"
;
Source: bin\{#CORE}_f.dll; DestDir: {app}\bin; Components: {#COMPN_SCILAB}
Source: bin\{#CORE}_f.lib; DestDir: {app}\bin; Components: {#COMPN_SCILAB}
Source: bin\{#CORE}.dll; DestDir: {app}\bin; Components: {#COMPN_SCILAB}
Source: bin\{#CORE}.lib; DestDir: {app}\bin; Components: {#COMPN_SCILAB}
Source: bin\{#CORE}_gw.dll; DestDir: {app}\bin; Components: {#COMPN_SCILAB}

;
Source: modules\{#CORE}\jar\org.scilab.modules.{#CORE}.jar;DestDir: {app}\modules\{#CORE}\jar; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
;
Source: modules\{#CORE}\license.txt; DestDir: {app}\modules\{#CORE}; Components: {#COMPN_SCILAB}
;
Source: modules\{#CORE}\etc\{#CORE}.quit; DestDir: {app}\modules\{#CORE}\etc; Components: {#COMPN_SCILAB}
Source: modules\{#CORE}\etc\{#CORE}.start; DestDir: {app}\modules\{#CORE}\etc; Components: {#COMPN_SCILAB}
Source: modules\{#CORE}\etc\help_text.xsl; DestDir: {app}\modules\{#CORE}\etc; Components: {#COMPN_SCILAB}
;
Source: modules\{#CORE}\includes\*.h; DestDir: {app}\modules\{#CORE}\includes; Flags: recursesubdirs; Components: {#COMPN_SCILAB}
Source: modules\{#CORE}\includes\*.hxx; DestDir: {app}\modules\{#CORE}\includes; Flags: recursesubdirs; Components: {#COMPN_SCILAB}
;
Source: modules\{#CORE}\macros\buildmacros.sce; DestDir: {app}\modules\{#CORE}\macros; Components: {#COMPN_SCILAB}
Source: modules\{#CORE}\macros\buildmacros.bat; DestDir: {app}\modules\{#CORE}\macros; Components: {#COMPN_SCILAB}
Source: modules\{#CORE}\macros\cleanmacros.bat; DestDir: {app}\modules\{#CORE}\macros; Components: {#COMPN_SCILAB}
Source: modules\{#CORE}\macros\lib; DestDir: {app}\modules\{#CORE}\macros; Components: {#COMPN_SCILAB}
Source: modules\{#CORE}\macros\*.sci; DestDir: {app}\modules\{#CORE}\macros; Components: {#COMPN_SCILAB}
Source: modules\{#CORE}\macros\*.bin; DestDir: {app}\modules\{#CORE}\macros; Components: {#COMPN_SCILAB}
;
Source: modules\{#CORE}\xml\*.dtd; DestDir: {app}\modules\{#CORE}\xml; Components: {#COMPN_SCILAB}
;
Source: modules\{#CORE}\demos\*.*; DestDir: {app}\modules\{#CORE}\demos; Flags: recursesubdirs; Components: {#COMPN_SCILAB}
;
Source: modules\{#CORE}\tests\*.*; DestDir: {app}\modules\{#CORE}\tests; Flags: recursesubdirs; Components: {#COMPN_SCILAB} and {#COMPN_TESTS}
;
Source: modules\{#CORE}\inline\*.*; DestDir: {app}\modules\{#CORE}\inline; Flags: recursesubdirs; Components: {#COMPN_SCILAB}
;
Source: modules\{#CORE}\help\*.*; DestDir: {app}\modules\{#CORE}\help; Flags: recursesubdirs; Components: {#COMPN_SCILAB}
;--------------------------------------------------------------------------------------------------------------
