//
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA
//
// This file is distributed under the same license as the Scilab package.
//

// =============================================================================
// demo_sphere()
// =============================================================================

function demo_sphere()

    [x, y, z] = sphere(40);

    my_handle                   = scf(100001);
    clf(my_handle,"reset");
    my_axe                      = my_handle.children;

    demo_viewCode("sphere.sce");

    my_handle.immediate_drawing = "off";
    plot3d2(x,y,z);
    isoview()
    my_plot                     = my_axe.children;
    my_handle.color_map         = jet(128);
    my_plot.color_flag          = 1;
    my_axe.rotation_angles      = [51,96];
    my_handle.immediate_drawing = "on";

endfunction

demo_sphere();
clear demo_sphere;
