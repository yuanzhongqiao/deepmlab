// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = spectral(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    spectralData = [
        158,1,66
        213,62,79
        244,109,67
        253,174,97
        254,224,139
        255,255,191
        230,245,152
        171,221,164
        102,194,165
        50,136,189
        94,79,162
    ] / 255;

    cmap = %_InterpolatedColormap(spectralData, n, "linear");
endfunction
