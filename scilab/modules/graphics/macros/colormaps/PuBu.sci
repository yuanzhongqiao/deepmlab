// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = PuBu(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    PuBu_Data = [
        255,247,251
        236,231,242
        208,209,230
        166,189,219
        116,169,207
        54,144,192
        5,112,176
        4,90,141
        2,56,88
    ] / 255;

    cmap = %_InterpolatedColormap(PuBu_Data, n, "spline");
endfunction
