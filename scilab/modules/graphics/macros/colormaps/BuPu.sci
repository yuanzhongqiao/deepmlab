// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = BuPu(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    BuPu_Data = [
        247,252,253
        224,236,244
        191,211,230
        158,188,218
        140,150,198
        140,107,177
        136,65,157
        129,15,124
        77,0,75
    ] / 255;

    cmap = %_InterpolatedColormap(BuPu_Data, n, "linear");
endfunction
