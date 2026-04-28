//
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA
//
// This file is distributed under the same license as the Scilab package.
//

// Show a Beziercurve of dimension 3

function bezier3dtest ()
    my_handle = scf(100001);
    clf(my_handle,"reset");

    p=[-1,-1,-1;0,-1,-1;1,0,0;1,1,0;0,1,1;-1,1,0];
    t=linspace(0,1,300);
    s=bezier(p,t);
    param3d(p(:,1),p(:,2),p(:,3),34,45);
    e = gce();
    e.mark_mode = "on";
    e.mark_style = 10;
    e.line_mode = "off";
    e.mark_foreground = color(209, 81, 4);
    e.mark_size = 2;

    param3d(s(:,1),s(:,2),s(:,3),34,45,"x@y@z",[0,0]);
    e = gce();
    e.foreground = color(39, 115, 191);
    e = gce();
    e.thickness = 3;
    a = gca();
    a.data_bounds = [-1.2 -1.2 -1.2;1.2 1.2 1.2];
    xtitle("A 3d polygon and its Bezier curve");
    ax.title.font_size = 3;

    demo_viewCode("bezier3dtest.sce");
endfunction

bezier3dtest();
clear bezier3dtest;
