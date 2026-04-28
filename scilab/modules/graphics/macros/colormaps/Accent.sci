// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = Accent(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = 0 // Default value is ignored later (nargin < 1 case)
    end

    // Colormap data inspired from https://colorbrewer2.org/
    data = [
        127,201,127
        190,174,212
        253,192,134
        255,255,153
        56,108,176
        240,2,127
        191,91,23
        102,102,102
    ] / 255;

    if nargin < 1 then
        cmap = data;
        return
    end

    cmap = %_ExtendedColormap(data, n);
endfunction
