// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = greens(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    // Colormap data inspired from https://colorbrewer2.org/
    greensData = [
        247,252,245
        229,245,224
        199,233,192
        161,217,155
        116,196,118
        65,171,93
        35,139,69
        0,109,44
        0,68,27
    ] / 255;

    cmap = %_InterpolatedColormap(greensData, n, "linear");
endfunction
