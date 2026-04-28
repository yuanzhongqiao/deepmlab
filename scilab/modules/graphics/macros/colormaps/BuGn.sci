// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = BuGn(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    BuGn_Data = [
        247,252,253
        229,245,249
        204,236,230
        153,216,201
        102,194,164
        65,174,118
        35,139,69
        0,109,44
        0,68,27
    ] / 255;

    cmap = %_InterpolatedColormap(BuGn_Data, n, "linear");
endfunction
