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

function out = %datetime_c_datetime(dt1, dt2)

    if size(dt1, "*") <> 0 && size(dt2, "*") <> 0 && size(dt1, "r") <> size(dt2, "r") then
        error(msprintf(_("%s: Wrong size for input arguments #%d and #%d: Same size expected.\n"), "%datetime_c_datetime", 1, 2))
    end

    f = [];
    if dt1.format <> [] then
        f = dt1.format;
    elseif dt2.format <> [] then
        f = dt2.format;
    end

    out = mlist(["datetime", "date", "time", "format"], [dt1.date dt2.date], [dt1.time dt2.time], f);
endfunction
