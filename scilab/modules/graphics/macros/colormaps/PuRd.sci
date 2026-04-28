// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = PuRd(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    PuRd_Data = [
        247,244,249
        231,225,239
        212,185,218
        201,148,199
        223,101,176
        231,41,138
        206,18,86
        152,0,67
        103,0,31
    ] / 255;

    cmap = %_InterpolatedColormap(PuRd_Data, n, "linear");
endfunction
