// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = purples(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    purplesData = [
        252,251,253
        239,237,245
        218,218,235
        188,189,220
        158,154,200
        128,125,186
        106,81,163
        84,39,143
        63,0,125
    ] / 255;

    cmap = %_InterpolatedColormap(purplesData, n, "spline");
endfunction
