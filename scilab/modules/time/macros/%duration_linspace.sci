// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function out = %duration_linspace(d1, d2, n)
    arguments
        d1 (1,1) {mustBeA(d1, ["double", "duration"])}
        d2 (1,1) {mustBeA(d1, ["double", "duration"])}
        n (1,1) {mustBeA(n, "double"), mustBeInteger, mustBePositive} 
    end

    f = [];
    isdurad1 = %f;
    if isduration(d1) then
        isdurad1 = %t;
        f = d1.format;
    else
        d1 = days(d1);
    end

    if isduration(d2) then
        if ~isdurad1 then
            f = d2.format;
        end
    else
        d2 = days(d2);
    end

    l = linspace(d1.duration, d2.duration, n);
    out = mlist(["duration", "duration", "format"], l, f);
endfunction