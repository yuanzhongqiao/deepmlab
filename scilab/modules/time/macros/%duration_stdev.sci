// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function out = %duration_stdev(d, orient, m)
    arguments
        d {mustBeA(d, "duration")}
        orient (1, 1) {mustBeA(orient, ["double", "string"]), mustBeMember(orient, {1, 2, "r", "c", "*"})} = "*"
        m {mustBeA(m, "double")} = []
    end

    if m == [] then
        s = stdev(d.duration, orient);
    else
        s = stdev(d.duration, orient, m);
    end

    out = mlist(["duration", "duration", "format"], s, d.format);
endfunction
