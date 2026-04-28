// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - UTC - Stéphane MOTTELET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function demo_surf()

    my_handle             = scf(100001);
    clf(my_handle,"reset");
    demo_viewCode("surf.dem.sce");

    // DEMO START

    my_plot_desc          = "surf";
    my_handle.figure_name = my_plot_desc;

    f = gcf();
    if ~isDocked(f)
        f.axes_size = [790, 570];
    end

    subplot(2,2,1);
    nc = 128;
    gcf().color_map = [coolwarm(nc); spectral(nc)];
    [X,Y]=meshgrid(-1:0.1:1,-1:0.1:1);
    surf(X,Y,X.^2-Y.^2,"facecolor","interp","edgecolor")
    gce().color_range = [nc+1 2*nc];
    
    subplot(2,2,2);
    surf(X,Y,-X.^2-Y.^2,"facecolor","interp");
    gce().color_range = [1 nc];
    
    subplot(2,2,3);
    surf(X,Y,X.^2-Y.^2,"facecolor","interp");
    gce().color_range = [nc+1 2*nc];
    gce().cdata_bounds = [0 1];
    
    subplot(2,2,4);
    surf(X,Y,-X.^2-Y.^2,"facecolor","interp");
    gce().color_range = [1 nc];
    gce().cdata_bounds = [-1 -0.5];
    
    // DEMO END

endfunction

demo_surf();
clear demo_surf;
