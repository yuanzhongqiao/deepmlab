// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = %_InterpolatedColormap(data, cmapSize, interpMode)

    // Internal/Private function used to generate colormaps based on https://colorbrewer2.org/ data

    indexes = 0:(size(data, "r") - 1);
    red = data(:,1)';
    green = data(:,2)';
    blue = data(:,3)';
    pIndexes = indexes/(size(data, "r") - 1) * cmapSize;
    cmap = [
        interp1(pIndexes, red, 0:(cmapSize - 1), interpMode)', ...
        interp1(pIndexes, green, 0:(cmapSize - 1), interpMode)', ...
        interp1(pIndexes, blue, 0:(cmapSize - 1), interpMode)'
    ];

endfunction
