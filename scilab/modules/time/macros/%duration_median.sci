// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function out = %duration_median(d, orient)
    arguments
        d {mustBeA(d, "duration")}
        orient (1, 1) {mustBeA(orient, ["double", "string"])} = "*"
    end

    m = median(d.duration, orient);
    out = mlist(["duration", "duration", "format"], m, d.format);
endfunction
