// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = YlGnBu(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    YlGnBu_Data = [
        255,255,217
        237,248,177
        199,233,180
        127,205,187
        65,182,196
        29,145,192
        34,94,168
        37,52,148
        8,29,88
    ] / 255;

    cmap = %_InterpolatedColormap(YlGnBu_Data, n, "linear");
endfunction
