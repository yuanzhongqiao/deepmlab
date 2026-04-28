// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

//=============================================================================
function VSPath = dlwGetVisualStudioPath()
    VSPath = "";

    versions = getVsWhereInformation();
    version = dlwFindMsVcCompiler();

    idx = 1;
    if size(versions, "*") > 1 then
        idx = findinlist(versions.name, version);
    end
    
    VSPath = versions(idx).path;
endfunction
//=============================================================================
