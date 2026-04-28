// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = Pastel2(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = 0 // Default value is ignored later (nargin < 1 case)
    end

    // Colormap data inspired from https://colorbrewer2.org/
    data = [
        179,226,205
        253,205,172
        203,213,232
        244,202,228
        230,245,201
        255,242,174
        241,226,204
        204,204,204
    ] / 255;

    if nargin < 1 then
        cmap = data;
        return
    end

    cmap = %_ExtendedColormap(data, n);
endfunction
