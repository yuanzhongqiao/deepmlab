// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = coolwarm(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap generated from http://www.kennethmoreland.com/color-maps/CoolWarmFloat257.csv
    indexes = [0, 74, 128, 176, 255];
    red = [0.230, 0.607, 0.865, 0.97, 0.706];
    green = [0.299, 0.735, 0.865, 0.694, 0.016];
    blue = [0.754, 0.999, 0.865, 0.579, 0.150];
    pIndexes = indexes/255 * n;
    cmap = [interp1(pIndexes, red, 0:(n - 1), "spline")', ...
            interp1(pIndexes, green, 0:(n - 1), "spline")', ...
            interp1(pIndexes, blue, 0:(n - 1), "spline")'];
endfunction
