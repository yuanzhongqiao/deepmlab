// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = RdBu(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    RdBu_Data = [
        103,0,31
        178,24,43
        214,96,77
        244,165,130
        253,219,199
        247,247,247
        209,229,240
        146,197,222
        67,147,195
        33,102,172
        5,48,97
    ] / 255;

    cmap = %_InterpolatedColormap(RdBu_Data, n, "linear");
endfunction
