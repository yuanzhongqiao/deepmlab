// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function demo_new_colormaps()

    colormapList = ["blues", "greens", "greys", "oranges", "purples", "reds",...
    "BuGn", "BuPu", "GnBu", "OrRd", "PuBu", "PuBuGn", "PuRd", "RdPu", "YlGn", "YlGnBu", "YlOrBr", "YlOrRd", ...
    "BrBG", "PiYG", "PRGn", "PuOr", "RdBu", "RdGy", "RdYlBu", "RdYlGn", "spectral", "coolwarm"];

    //Compute gigantic colormap
    cmap=[];
    for i=colormapList
        cmap = [cmap ; evstr(i + "(128)")]
    end

    n = size(colormapList, '*');
    M = zeros(128, n);
    M(:) = 1:size(M, '*');
    M = M'

    f=scf(100001);
    clf(f, "reset");
    demo_viewCode("additional_colormaps.dem.sce");
    f.figure_name = _("Additional colormaps");
    Matplot(M)
    f.color_map = cmap;
    a=gca();
    a.axes_visible = ["off", "on", "off"];
    a.auto_ticks = "off";
    locations = (1:size(colormapList, '*'))'
    labels = colormapList($:-1:1)';
    a.y_ticks = tlist(["ticks" "locations" "labels"], locations, labels);
    a.sub_ticks = [0 0]
endfunction

demo_new_colormaps();
clear demo_new_colormaps;
