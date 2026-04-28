// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) ????-2008 - INRIA
// Copyright (C) 2011 - DIGITEO - Allan CORNET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function subdemolist = demo_gateway()
    demopath = get_absolute_file_path("cacsd.dem.gateway.sce");
    _("Control Systems - CACSD");  // lets gettext() harvesting it
    add_demo("Control Systems - CACSD", demopath + "cacsd.dem.gateway.sce");

    subdemolist = [_("LQG")                , "lqg/lqg.dem.sce"
    _("Mixed-sensitivity")  , "mixed.dem.sce"
    _("PID")                , "pid.dem.sce"
    _("Inverted pendulum")  , "pendulum/pendule.dem.sce"
    _("Flat systems")       , "flat/flat.dem.gateway.sce"
    _("Tracking")           , "tracking/track.dem.sce"
    _("Robust control")     , "robust/rob.dem.sce"]

    subdemolist(:,2) = demopath + subdemolist(:,2);
endfunction

subdemolist = demo_gateway();
clear demo_gateway;
