// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Allan CORNET
// Copyright (C) 2012 - Scilab Enterprises - Adeline CARNIS
// Copyright (C) 2012 - 2016 - Scilab Enterprises
// Copyright (C) 2024 - Dassault Systèmes S.E. - Bruno JOFRET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function demo_rosenbrock()

    mprintf(_("Running optimization ...\n"));

    function z = rosenbrockSurf(x, y)
         z = 100 * (y - x^2)^2 + (1 - x)^2;
    endfunction
    
    function [ f , g , ind ] = rosenbrock ( x , ind )
        f = rosenbrockSurf(x(1), x(2));
        g(1) = - 400. * ( x(2) - x(1)**2 ) * x(1) -2. * ( 1. - x(1) )
        g(2) = 200. * ( x(2) - x(1)**2 )
        if (ind == 1) then
            mprintf("f(x) = %s, x=%f, y=%f\n", string(f), x(2), x(1))
            e = get("rosenbrockCurOptim");
            e.data = [e.data ; x(1), x(2), f]
            sleep(200)
        end
    endfunction

    fig = scf(100001);
    clf(fig, "reset");
    demo_viewCode("optim_rosenbrock.sce");
    xx= linspace(-1.5, 1.5, 50);
    yy= linspace(-1, 1.5, 50);
    fplot3d(xx, yy, rosenbrockSurf);
    e = gce();
    e.color_flag = 1;
    f.color_map = jet(32);
    
    x0 = [-1.2 1];
    scatter3d(x0(1), x0(2), rosenbrockSurf(x0(1), x0(2)))
    e = gce();
    e.mark_foreground = color("red")
    e.mark_background = color("red")
    e.tag = "rosenbrockCurOptim";

    [f, x] = optim(rosenbrock, x0, iprint = -1);

    scatter3d(x(1), x(2), f)
    e = gce();
    e.mark_foreground = color("green")
    e.mark_background = color("green")


    //
    // Display results
    //
    mprintf("x = %s\n", strcat(string(x)," "));
    mprintf("f = %e\n", f);

endfunction

demo_rosenbrock();
clear demo_rosenbrock;


















