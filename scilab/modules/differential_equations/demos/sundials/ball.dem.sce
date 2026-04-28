//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - UTC - Stéphane MOTTELET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function demo_ball()
    function out = res(t, y, yd)
        x = y(1:2);
        xd = yd(1:2);
        u = y(3:4);
        ud = yd(3:4);
        lambda = y(5);
        // last component is the complementarity equation
        out = [xd-u; ud+G+x*lambda; lambda*(x'*u)];
        if x(2)<%eps
            // spring of 1/%eps stiffness causes bouncing
            out(4) = out(4)-(1-x(2)/%eps); 
        end 
    end

    R = 2;
    T = 2.5;
    G = [0;9.81];
    x0 = [0;R];
    u0 = [0.5;0];
    lambda0 = min(0,(u0'*u0-x0'*G)/(x0'*x0));
    ud0 = -x0*lambda0-G;
    y0 = [x0;u0;lambda0];
    yd0 = [u0;ud0;0];

    // nonPositive option allows to keep lambda <= 0, allowing ball takeoff 
    sol = ida(res,[0 T],y0,yd0,yIsAlgebraic=5,suppressAlg=%t,nonPositive=5)

    clf
    demo_viewCode("ball.dem.sce")

    th = linspace(0,2*%pi,128);
    clf;plot(R*cos(th),R*sin(th),x0(1),x0(2),'o');
    h = gce().children(1);
    isoview on
    gca.data_bounds(2:3) = [sol.y(1,$),0];
    title(msprintf("$\\lambda = %4.1f$",lambda0))
    ht = gca().title;

    realtimeinit(1)
    realtime(0)
    for t = linspace(0,sol.t($),500)
        realtime(t)
        if ~is_handle_valid(h) then break; end
        y = sol(t);
        h.data = y(1:2)';
        ht.text = msprintf("$\\lambda = %4.1f$",y(5));
    end
end

demo_ball()
clear demo_ball
