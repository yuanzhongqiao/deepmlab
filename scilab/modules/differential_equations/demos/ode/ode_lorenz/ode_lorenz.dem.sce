// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) ????-2008 - INRIA
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

// ODE definition

function demo_ode_lorenz()

    function ydot=lorenz(t,y)
        x    = y(1);
        a    = [-10,10,0;28,-1,-x;0,x,-8/3];
        ydot = a*y
    endfunction

    function j=jacobian(t,y)
        x  = y(1);
        yy = y(2);
        z  = y(3);
        j  = [-10,10,0;28-z,-1,-x;-yy,x,-8/3]
    endfunction

    // Integration

    y0       = [-3;-6;12];
    t0       = 0;
    step     = 0.01;
    t1       = 10;
    instants = t0:step:t1;
    y        = ode(y0,t0,instants,lorenz,jacobian);

    // Visualization - animation

    my_handle = scf(100001);
    clf(my_handle,"reset");
    demo_viewCode("ode_lorenz.dem.sce");
    title(_("Lorenz differential equation"))
    my_handle.axes_size = [605 585];

    function h = poly3d(x,y,z)
        xpoly(x,y);h=gce();h.data(:,3)=z
    endfunction

    curAxe = gca();

    drawlater()
    curAxe                 = gca();
    curAxe.view            = "3d"
    curAxe.axes_visible    = "on"
    curAxe.data_bounds     = [min(y,"c")';max(y,"c")']
    curAxe.margins(3)      = 0.25;
    curAxe.title.text      = [_("Lorenz differential equation")
    "$\left\{\begin{array}{rl} \frac{dy_1}{dt} &= -10y_1 + 10y_2 \\ \frac{dy_2}{dt} &= 28y_1 - y_2 - y_1y_3 \\ \frac{dy_3}{dt} &= y_1y_2 - \frac{8}{3}y_3\end{array}\right.$"
    ]
    curAxe.grid            = curAxe.hidden_axis_color*ones(1,3);
    curAxe.x_label.text    = "$y_1$"
    curAxe.y_label.text    = "$y_2$"
    curAxe.z_label.text    = "$y_3$"

    //the trace
    p = poly3d(y(1,1),y(2,1),y(3,1));
    drawnow()

    //Animate
    for k=1:size(y,2)
        sleep(10)
        if ~is_handle_valid(my_handle) then
            break;
        end

        if is_handle_valid(p) then
            p.data=[p.data;
            y(1:3,k)'];
        else
            break;
        end
    end
endfunction

demo_ode_lorenz();
clear demo_ode_lorenz;
