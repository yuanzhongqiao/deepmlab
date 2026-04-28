// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = PuOr(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    PuOr_Data = [
        179,88,6
        224,130,20
        253,184,99
        254,224,182
        247,247,247
        216,218,235
        178,171,210
        128,115,172
        84,39,136
    ] / 255;

    cmap = %_InterpolatedColormap(PuOr_Data, n, "linear");
endfunction
