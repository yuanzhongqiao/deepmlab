// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function out = %duration_mean(d, orient)
    arguments
        d {mustBeA(d, "duration")}
        orient (1, 1) {mustBeA(orient, ["double", "string"]), mustBeMember(orient, {1, 2, "r", "c", "*"})} = "*"
    end

    m = mean(d.duration, orient);
    out = mlist(["duration", "duration", "format"], m, d.format);
endfunction
