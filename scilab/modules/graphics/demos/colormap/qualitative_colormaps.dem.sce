// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function demo_qualitative_colormaps()

    colormapList = ["flag", "prism", "Accent", "Dark2", "Paired", "Pastel1", "Pastel2", "Set1", "Set2", "Set3"];

    //Compute gigantic colormap
    cmap=[];
    for i=colormapList
        cmap = [cmap ; evstr(i + "(12)")]; // 12 is the size of the base pattern for biggest discrete colormaps currently available in Scilab
    end

    n = size(colormapList, '*');
    M = zeros(12, n);
    M(:) = 1:size(M, '*');
    M = M'

    f=scf(100001);
    clf(f, "reset");
    demo_viewCode("qualitative_colormaps.dem.sce");
    f.figure_name = _("Qualitative colormaps");
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

demo_qualitative_colormaps();
clear demo_qualitative_colormaps;
