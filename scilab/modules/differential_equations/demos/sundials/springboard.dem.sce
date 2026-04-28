//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022-2023 - UTC - Stéphane MOTTELET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function demo_springboard()
    function out = res(t, y, yd)
        x = y(1:2);
        xd = yd(1:2);
        u = y(3:4);
        ud = yd(3:4);
        lambda = y(5);
        // last component is the complementarity equation
        g = grad(x);
        out = [xd-u; ud+G+g*lambda; lambda*(g'*u)];
        if x(2)<%eps
            // spring of 1/%eps stiffness causes bouncing
            out(4) = out(4)-(1-x(2)/%eps); 
        end 
    end
    function y=f(x)
        y = -x.^3+2*x.^2+0.1;
    endfunction
    function g=grad(x)
        // gradient of F(x,y)=y-f(x) with complex step
        g = [imag(-f(x(1)+%i*1e-100))/1e-100;1];
    endfunction

    T = 3;
    G = [0;9.81];
    x01 = -1;
    x0 = [x01;f(x01)];
    u0 = [0;0];
    g0 = grad(x0);
    lambda0 = -g0'*G/(g0'*g0);
    ud0 = -g0*lambda0-G;
    y0 = [x0;u0;lambda0];
    yd0 = [u0;ud0;0];

    // nonPositive option allows to keep lambda <= 0, allowing ball takeoff 
    sol = ida(res,[0 T],y0,yd0,yIsAlgebraic=5,suppressAlg=%t,nonPositive=5)

    my_handle = scf(100001);
    clf(my_handle,"reset");
    demo_viewCode("springboard.dem.sce");

    x=linspace(min(sol.y(1,:)),3,100);
    plot(x,f(x),x0(1),x0(2),'o');
    h = gce().children(1);
    isoview on
    gca.data_bounds(1:3) = [min(sol.y(1,:)) max(sol.y(1,:)),0];
    title(msprintf("$\\lambda = %4.1f$",lambda0))
    ht = gca().title;

    realtimeinit(1)
    realtime(0)
    for t = linspace(0,sol.t($),500)
        realtime(t)
        y = sol(t);
        if ~is_handle_valid(h) then break; end
        h.data = y(1:2)';
        ht.text = msprintf("$\\lambda = %4.1f$",y(5));
    end
end

demo_springboard()
clear demo_springboard
