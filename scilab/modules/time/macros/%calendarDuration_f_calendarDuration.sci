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

function out = %calendarDuration_f_calendarDuration(cd1, cd2)
    if size(cd1, "*") <> 0 && size(cd2, "*") <> 0 && size(cd1, "c") <> size(cd2, "c") then
        error(msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%calendarDuration_f_calendarDuration", 1, 2))
    end

    f = [];
    if cd1.format <> [] then
        f = cd1.format;
    elseif cd2.format <> [] then
        f = cd2.format;
    end

    out = mlist(["calendarDuration", "y", "m" "d", "t", "format"], [cd1.y;cd2.y], [cd1.m;cd2.m], [cd1.d;cd2.d], [cd1.t;cd2.t], f);
endfunction
