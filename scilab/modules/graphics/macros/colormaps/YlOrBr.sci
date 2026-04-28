// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = YlOrBr(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    YlOrBr_Data = [
        255,255,229
        255,247,188
        254,227,145
        254,196,79
        254,153,41
        236,112,20
        204,76,2
        153,52,4
        102,37,6
    ] / 255;

    cmap = %_InterpolatedColormap(YlOrBr_Data, n, "spline");
endfunction
