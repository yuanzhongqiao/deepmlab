// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Scilab Enterprises - Vincent COUVERT
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

demopath = get_absolute_file_path("colormap.dem.gateway.sce");

subdemolist = [                                   ..
_("Classical colormaps")      , "colormaps.dem.sce"    ; ..
_("Additional colormaps")    , "additional_colormaps.dem.sce"       ; ..
_("Interactive colormaps")    , "interactive_colormap.dem.sce"       ; ..
_("Qualitative colormaps")    , "qualitative_colormaps.dem.sce"       ; ..
_("Scilab colormaps")    , "scilab_colormaps.dem.sce"       ; ..
_("Figure/Axes colormaps")    , "figure_axes_colormaps.dem.sce"       ];

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
