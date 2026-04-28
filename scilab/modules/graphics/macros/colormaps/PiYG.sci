// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = PiYG(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    PiYG_Data = [
        142,1,82
        197,27,125
        222,119,174
        241,182,218
        253,224,239
        247,247,247
        230,245,208
        184,225,134
        127,188,65
        77,146,33
        39,100,25
    ] / 255;

    cmap = %_InterpolatedColormap(PiYG_Data, n, "linear");
endfunction
