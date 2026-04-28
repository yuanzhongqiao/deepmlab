// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = Paired(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = 0 // Default value is ignored later (nargin < 1 case)
    end

    // Colormap data inspired from https://colorbrewer2.org/
    data = [
        166,206,227
        31,120,180
        178,223,138
        51,160,44
        251,154,153
        227,26,28
        253,191,111
        255,127,0
        202,178,214
        106,61,154
        255,255,153
        177,89,40
    ] / 255;

    if nargin < 1 then
        cmap = data;
        return
    end

    cmap = %_ExtendedColormap(data, n);
endfunction
