// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
// For more information, see the COPYING file which you should have received
// along with this program.

function cmap = %_ExtendedColormap(data, cmapSize)

    // Internal/Private function used to generate qualitative colormaps

    if size(data, 1) < cmapSize then // Replicate data as much as needed
        data = repmat(data, int(cmapSize / size(data, 1)) + 1, 1);
    end

    cmap = data(1:cmapSize, :);

endfunction
