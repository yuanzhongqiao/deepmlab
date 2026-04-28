//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function subdemolist = demo_gateway()
    demopath = get_absolute_file_path("sundials.dem.gateway.sce");

    subdemolist = ["Minimal surface", "minimal.dem.sce"
                  "Lorenz attractor", "lorenz.dem.sce"
                  "Parameter identification in ODE", "demo_sir_ident.sce"
                  "Single pendulum" ,"demo_single_pendulum.sce"
                  "Spherical pendulum", "pend3d1.dem.sce"
                  "User spline sliding pendulum","demo_spline_pendulum.sce"
                  "N-pendulum","demo_npend.sce"
                  "Collapsing chain","demo_chain.sce"
                  "Springboard", "springboard.dem.sce"];
    subdemolist(:,2) = demopath + subdemolist(:,2);
endfunction

subdemolist = demo_gateway();
clear demo_gateway;
