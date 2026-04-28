// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function demo_figure_axes_colormaps()

    f=scf(100001);
    clf(f, "reset");
    demo_viewCode("figure_axes_colormaps.dem.sce");
    f.figure_name = _("Figure & Axes colormaps");
    f.color_map = jet(32);

    x = %pi * [-1:0.05:1]';
    z = sin(x)*cos(x)';
    
    ax1 = subplot(1, 2, 1);
    ax1.title.text = "plot3d() using figure colormap"
    e = plot3d(x, x, z, 70, 70);
    e.color_flag = 1;


    ax2 = subplot(1, 2, 2);
    ax2.title.text = "plot3d() using axes colormap"
    ax2.color_map = parula(32)
    e = plot3d(x, x, z, 70, 70);
    e.color_flag = 1;

endfunction

demo_figure_axes_colormaps();
clear demo_figure_axes_colormaps;
