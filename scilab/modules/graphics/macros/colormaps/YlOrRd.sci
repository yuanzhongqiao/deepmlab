// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = YlOrRd(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    YlOrRd_Data = [
        255,255,204
        255,237,160
        254,217,118
        254,178,76
        253,141,60
        252,78,42
        227,26,28
        189,0,38
        128,0,38
    ] / 255;

    cmap = %_InterpolatedColormap(YlOrRd_Data, n, "linear");
endfunction
