// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = BrBG(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    BrBG_Data = [
        84,48,5
        140,81,10
        191,129,45
        223,194,125
        246,232,195
        245,245,245
        199,234,229
        128,205,193
        53,151,143
        1,102,94
        0,60,48
    ] / 255;

    cmap = %_InterpolatedColormap(BrBG_Data, n, "linear");
endfunction
