// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = Pastel1(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = 0 // Default value is ignored later (nargin < 1 case)
    end

    // Colormap data inspired from https://colorbrewer2.org/
    data = [
        251,180,174
        179,205,227
        204,235,197
        222,203,228
        254,217,166
        255,255,204
        229,216,189
        253,218,236
        242,242,242
    ] / 255;

    if nargin < 1 then
        cmap = data;
        return
    end

    cmap = %_ExtendedColormap(data, n);
endfunction
