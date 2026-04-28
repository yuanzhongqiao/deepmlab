// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = RdYlGn(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    RdYlGn_Data = [
        165,0,38
        215,48,39
        244,109,67
        253,174,97
        254,224,139
        255,255,191
        217,239,139
        166,217,106
        102,189,99
        26,152,80
        0,104,55
    ] / 255;

    cmap = %_InterpolatedColormap(RdYlGn_Data, n, "linear");
endfunction
