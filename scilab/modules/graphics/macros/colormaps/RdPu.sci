// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = RdPu(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    RdPu_Data = [
        255,247,243
        253,224,221
        252,197,192
        250,159,181
        247,104,161
        221,52,151
        174,1,126
        122,1,119
        73,0,106
    ] / 255;

    cmap = %_InterpolatedColormap(RdPu_Data, n, "linear");
endfunction
