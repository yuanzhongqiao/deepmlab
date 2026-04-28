// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = RdYlBu(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    RdYlBu_Data = [
        165,0,38
        215,48,39
        244,109,67
        253,174,97
        254,224,144
        255,255,191
        224,243,248
        171,217,233
        116,173,209
        69,117,180
        49,54,149
    ] / 255;

    cmap = %_InterpolatedColormap(RdYlBu_Data, n, "linear");
endfunction
