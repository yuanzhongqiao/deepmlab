// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = GnBu(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    GnBu_Data = [
        247,252,240
        224,243,219
        204,235,197
        168,221,181
        123,204,196
        78,179,211
        43,140,190
        8,104,172
        8,64,129
    ] / 255;

    cmap = %_InterpolatedColormap(GnBu_Data, n, "spline");
endfunction
