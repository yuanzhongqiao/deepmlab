// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
// For more information, see the COPYING file which you should have received
// along with this program.

function s = %_GetDefaultColormapSize()

    // Internal/Private function used to determine default color map size

    if isempty(winsid()) then
       s = size(gdf().color_map, 1);
    else
       s = size(gcf().color_map, 1);
    end

endfunction
