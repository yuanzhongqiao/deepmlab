// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = PuBuGn(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    PuBuGn_Data = [
        255,247,251
        236,226,240
        208,209,230
        166,189,219
        103,169,207
        54,144,192
        2,129,138
        1,108,89
        1,70,54
    ] / 255;

    cmap = %_InterpolatedColormap(PuBuGn_Data, n, "linear");
endfunction
