//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function demo_pend3d1()

    function h = poly3d(x,y,z)
        xpoly(x,y);
        h = gce();
        h.data(:,3) = z;
        h.thickness=2
    endfunction

    my_handle = scf(100001);
    clf(my_handle);
    demo_viewCode("pend3d1.dem.sce");
    show_window
    m = 1;  // mass
    g = 10; // gravity
    l = 1;  // length

    theta0 = 0.2;
    phi0   = %pi/4;

    x0=l*[sin(phi0)*cos(theta0);cos(phi0)*cos(theta0);sin(theta0)];

    function c=ggpp(x,u,lambda)
        c = 2*(u'*u+x'*(-2*lambda/m*x-[0;0;g]));
    endfunction

    // initial compatible point
    // y0(7)=lambda0 and yd0 are computed by passing options
    // yIsAlgebraic=7, calcIc="y0yp0" to IDA
    u0      = [1;-1;0];
    y0      = [x0;u0;0];
    yd0     = zeros(7,1);
    t0      = 0;
    // interval of simulation
    T       = [0 15];

    //index 1 DAE model
    //-----------------
    function [res]=index1(t,y,ydot)
        x        = y(1:3);
        u        = y(4:6);
        lambda   = y(7);
        xp       = ydot(1:3);
        up       = ydot(4:6);
        lambdap  = ydot(7);
        res      = [xp-u
                    up+2*lambda/m*x+[0;0;g]
                    ggpp(x,u,lambda)];
    endfunction

    [T,y1] = ida(index1,T,y0,yd0,yIsAlgebraic=7,calcIc="y0yp0");
    x1=y1(1:3,:);

    //ode model with constraint (handled by projection)
    //-------------------------------------------------
    function [yd] = rhsc(t,y)
        x = y(1:3);
        u = y(4:6);
        yd = [u
              (g*x(3)-u'*u)*x+[0;0;-g]];
    endfunction
    function [corr,err] = projPend(t,y,err)
      x = y(1:3)
      u = y(4:6)
      // Project positions (constraint is norm(x) = 1)
      xnew = x/norm(x);
       // Project velocities (constraint is x'*u = 0)
      A = kernel(xnew');
      P = A*A';
      unew = P*u
      // Return position and velocity corrections
      corr = [xnew;unew] - [x;u];
      // Project error, if applicable
      if argn(1)==2
          err=[P*err(1:3);P*err(4:6)]
      end
    end

    [T,y1c] = cvode(rhsc,T,y0(1:6),projection=projPend,projectError=%t); 
    x1c = y1c(1:3,:);

    drawlater()
    title(_("spherical pendulum simulation"),"fontsize",3)
    isoview()
    a                 = gca();
    a.view            = "3d";
    a.box             = "off";
    a.margins         = [0.1 0 0.2 0.1];
    a.grid            =color("lightgray")*ones(1,3);
    a.rotation_angles = [35 45];
    a.axes_visible    = "on";
    a.data_bounds     = 1.1*l*[-1 1 -1 1 -1 1];
    
    poly3d(x0(1),x0(2),x0(3));
    gce().mark_style=9;
    p1=poly3d(x1(1,1),x1(2,1),x1(3,1));
    p1.foreground=color("scilabblue3");

    p1c=poly3d(x1c(1,1),x1c(2,1),x1c(3,1));
    p1c.foreground=color("scilabgreen3");

    l=legend([p1;p1c],["IDA index 1","CVODE projection"])
    drawnow();

    step=1;
    for k=1:step:(size(x1,2)-step)
        drawlater
        if ~is_handle_valid(my_handle) then
            break;
        end
        if is_handle_valid(p1) then
            p1.data = [p1.data
            x1(:,k:(k+step))'];
        end
        if is_handle_valid(p1c) then
            p1c.data = [p1c.data
            x1c(:,k:(k+step))'];
        end
        
        title(["spherical pendulum"
        msprintf("norm(x)=%9.7f (IDA index 1)",norm(x1(:,k)))
        msprintf("norm(x)=%9.7f (CVODE projection)",norm(x1c(:,k)))])
        drawnow
    end
    poly3d(x1(1,$),x1(2,$),x1(3,$));
    gce().mark_style=9;
    poly3d(x1c(1,$),x1c(2,$),x1c(3,$));
    gce().mark_style=9;


endfunction

demo_pend3d1();
clear demo_pend3d1;


