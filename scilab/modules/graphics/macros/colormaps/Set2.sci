// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = Set2(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = 0 // Default value is ignored later (nargin < 1 case)
    end

    // Colormap data inspired from https://colorbrewer2.org/
    data = [
        102,194,165
        252,141,98
        141,160,203
        231,138,195
        166,216,84
        255,217,47
        229,196,148
        179,179,179
    ] / 255;

    if nargin < 1 then
        cmap = data;
        return
    end

    cmap = %_ExtendedColormap(data, n);
endfunction
