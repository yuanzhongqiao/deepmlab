// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = YlGn(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    YlGn_Data = [
        255,255,229
        247,252,185
        217,240,163
        173,221,142
        120,198,121
        65,171,93
        35,132,67
        0,104,55
        0,69,41
    ] / 255;

    cmap = %_InterpolatedColormap(YlGn_Data, n, "linear");
endfunction
