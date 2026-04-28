// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Adeline CARNIS
// Copyright (C) 2022 - Dassault Systèmes S.E. - Antoine ELIAS
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function out = %duration_c_duration(dura1, dura2)
    if size(dura1, "*") <> 0 && size(dura2, "*") <> 0 && size(dura1, "r") <> size(dura2, "r") then
        error(msprintf(gettext("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%duration_c_duration", 1, 2))
    end

    f = [];
    if dura1.format then
        f = dura1.format;
    elseif dura2.format then
        f = dura2.format;
    end

    out = mlist(["duration", "duration", "format"], [dura1.duration dura2.duration], f);
endfunction
