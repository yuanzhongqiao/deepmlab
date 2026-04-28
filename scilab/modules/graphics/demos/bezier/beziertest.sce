//
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA
//
// This file is distributed under the same license as the Scilab package.
//

// a random polygon and a bezier curve

function beziertest

    my_handle = scf(100001);
    clf(my_handle,"reset");

    plot2d(-0.2,-0.2,0,"011"," ",[-0.2,-0.2,1,1]);
    title("Bezier Test : random polygon and bezier curve","fontsize",3);
    rand("uniform");
    p = rand(5, 2);
    t = linspace(0, 1, 300);
    s = bezier(p, t);

    drawlater()
    plot2d(p(:, 1),p(:, 2));
    e = gce().children;
    e.mark_mode = "on";
    e.mark_style = 10;
    e.mark_foreground = color(209, 81, 4);
    e.line_mode = "off";

    plot2d(s(:, 1), s(:, 2));
    e = gce().children;
    e.thickness = 3;
    e.foreground = color(39, 115, 191);
    drawnow();

    demo_viewCode("beziertest.sce");

endfunction

beziertest();
clear beziertest;
