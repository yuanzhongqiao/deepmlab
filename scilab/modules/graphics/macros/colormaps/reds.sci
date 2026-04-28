// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = reds(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    redsData = [
        255,245,240
        254,224,210
        252,187,161
        252,146,114
        251,106,74
        239,59,44
        203,24,29
        165,15,21
        103,0,13
    ] / 255;

    cmap = %_InterpolatedColormap(redsData, n, "linear");
endfunction
