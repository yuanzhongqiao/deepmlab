//
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA
//
// This file is distributed under the same license as the Scilab package.
//

// Show how two bezier surfaces can be joined.

function c1test()

    // first surface
    x1 = repmat([-0.5:0.25:0.5],5, 1);
    y1 = repmat([0,0,0,0,1], 5, 1);
    z1 = repmat([2:0.25:3]', 1, 5);

    n = 10;
    t = linspace(0, 1, n);
    b = bernstein(4, t);
    xb1 = b * x1 * b';
    yb1 = b * y1 * b';
    zb1 = b * z1 * b';

    // second surface
    x2 = x1;
    y2=[(ones(4,5));[0,0,0,0,0]];
    z2 = repmat([-1:0.25:0]', 1, 5);
    xb2 = b * x2 * b';
    yb2 = b * y2 * b';
    zb2 = b * z2 * b';

    // a surface to link the two previous ones'
    x = zeros(5, 5); 
    y = x; 
    z = x;

    x(1,:) = x1(1,:); 
    x(2,:) = x(1,:)-(x1(2,:)-x1(1,:));
    x(5,:) = x2(1,:); 
    x(4,:) = x(5,:)-(x2(2,:)-x2(1,:));
    x(3,:) = (x(4,:)+x(2,:))/2;

    y(1,:) = y1(1,:); 
    y(2,:) = y(1,:)-(y1(2,:)-y1(1,:));
    y(5,:) = y2(1,:); 
    y(4,:) = y(5,:)-(y2(2,:)-y2(1,:));
    y(3,:) = (y(4,:)+y(2,:))/2;

    z(1,:) = z1(1,:);
    z(2,:) = z(1,:)-(z1(2,:)-z1(1,:));
    z(5,:) = z2(1,:); 
    z(4,:) = z(5,:)-(z2(2,:)-z2(1,:));
    z(3,:) = (z(4,:)+z(2,:))/2;

    xb = b * x * b';
    yb = b * y * b';
    zb = b * z * b';

    A=35,T=50,L=" ",EB=[4,2,0];

    //drawing
    my_handle = scf(100001);
    clf(my_handle,"reset");
    my_current_axis = gca();
    drawlater();
    newaxes();
    gca().axes_bounds = [0 0 1 0.9];
    title("how two bezier surfaces can be joined","fontsize",3);
    subplot(2,2,1);
    plot3d2(xb1,yb1,zb1,-1,A,T,L,EB);
    subplot(2,2,3);
    plot3d2(xb2,yb2,zb2,-1,A,T,L,EB);
    subplot(1,2,2);
    [n1,p1]=size(xb1);
    [n2,p2]=size(xb);
    plot3d2([xb1;xb;xb2],[yb1;yb;yb2],[zb1;zb;zb2],-1,A,T,L,EB);
    delete(my_current_axis);
    drawnow();

    demo_viewCode("c1test.sce");

endfunction

c1test();
clear c1test;
