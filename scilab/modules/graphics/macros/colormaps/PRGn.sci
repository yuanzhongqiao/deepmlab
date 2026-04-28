// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = PRGn(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    PRGn_Data = [
        64,0,75
        118,42,131
        153,112,171
        194,165,207
        231,212,232
        247,247,247
        217,240,211
        166,219,160
        90,174,97
        27,120,55
        0,68,27
    ] / 255;

    cmap = %_InterpolatedColormap(PRGn_Data, n, "spline");
endfunction
