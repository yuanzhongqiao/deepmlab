// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = oranges(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    orangesData = [
        255,245,235
        254,230,206
        253,208,162
        253,174,107
        253,141,60
        241,105,19
        217,72,1
        166,54,3
        127,39,4
    ] / 255;

    cmap = %_InterpolatedColormap(orangesData, n, "linear");
endfunction
