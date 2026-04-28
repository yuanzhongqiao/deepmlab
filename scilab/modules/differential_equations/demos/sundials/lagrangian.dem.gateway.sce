//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.


demopath = get_absolute_file_path("lagrangian.dem.gateway.sce");

subdemolist = ["Single pendulum" ,"lagrangian/demo_single_pendulum.sce"
               "Double pendulum","lagrangian/demo_double_pendulum.sce"
               "Cardioid sliding pendulum","lagrangian/demo_cardioid_pendulum.sce"
               "User spline sliding pendulum","lagrangian/demo_spline_pendulum.sce"
               "N-pendulum","lagrangian/demo_npend.sce"
               "Collapsing chain","lagrangian/demo_chain.sce"]

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
