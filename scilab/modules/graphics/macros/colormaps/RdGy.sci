// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = RdGy(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    RdGy_Data = [
        103,0,31
        178,24,43
        214,96,77
        244,165,130
        253,219,199
        255,255,255
        224,224,224
        186,186,186
        135,135,135
        77,77,77
        26,26,26
    ] / 255;

    cmap = %_InterpolatedColormap(RdGy_Data, n, "linear");
endfunction
