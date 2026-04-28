//
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA
//
// This file is distributed under the same license as the Scilab package.
//

// Show a Bezier surface

function beziersurftest()

    x = linspace(-%pi, %pi, 5);
    y = repmat(x', 1, 5);
    x = repmat(x, 5, 1);
    z= 3 * sin(x) .* cos(y);

    n = 20;
    t = linspace(0, 1, n);
    b = bernstein(4, t);
    xb = b * x * b';
    yb = b * y * b';
    zb = b * z * b';
    
    my_handle = scf(100001);
    clf(my_handle,"reset");

    subplot(2,1,1);
    drawlater();
    plot3d3(x,y,z);
    title("A first surface","fontsize",3);
    subplot(2,1,2);
    plot3d2(xb,yb,zb,-1,35,45," ",[4,2,3]);
    title("The bezier interpolated surface (n=20)","fontsize",3);
    drawnow();
    demo_viewCode("beziersurftest.sce");

endfunction

beziersurftest();
clear beziersurftest;
