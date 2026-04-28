// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - Scilab Enterprises - Bruno JOFRET
// Copyright (C) 2023 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// Test Diagram with fromws after end behavior
// Input random values
//

loadXcosLibs();

props = scicos_params(tf=5000.5);

// recreate a diagram
objs = list()
objs(1) = CLOCK_c("define");
objs(1).model.rpar.objs(2).graphics.exprs = ["0.5" ; "0"];
objs(2) = CLKSPLIT_f("define");
objs(3) = CLKSPLIT_f("define");

objs(4) = FROMWSB("define");
objs(4).model.rpar.objs(1).graphics.exprs = ["V_in" ; "0" ; "1" ; "0"];
objs(5) = GAINBLK_f("define");
objs(6) = TOWS_c("define");
objs(6).graphics.exprs = ["10001" ; "V_out_zero" ; "0"];

objs(7) = FROMWSB("define");
objs(7).model.rpar.objs(1).graphics.exprs = ["V_in" ; "0" ; "1" ; "1"];
objs(8) = GAINBLK_f("define");
objs(9) = TOWS_c("define");
objs(9).graphics.exprs = ["10001" ; "V_out_hold" ; "0"];

objs(10) = FROMWSB("define");
objs(10).model.rpar.objs(1).graphics.exprs = ["V_in" ; "0" ; "1" ; "2"];
objs(11) = GAINBLK_f("define");
objs(12) = TOWS_c("define");
objs(12).graphics.exprs = ["10001" ; "V_out_repeat" ; "0"];

objs(13) = scicos_link(from=[1 1 0], to=[ 2 1 1], ct=[1 -1]);
objs(14) = scicos_link(from=[2 1 0], to=[ 6 1 1], ct=[1 -1]);
objs(15) = scicos_link(from=[2 2 0], to=[ 3 1 1], ct=[1 -1]);
objs(16) = scicos_link(from=[3 1 0], to=[ 9 1 1], ct=[1 -1]);
objs(17) = scicos_link(from=[3 2 0], to=[12 1 1], ct=[1 -1]);

objs(18) = scicos_link(from=[ 4 1 0], to=[ 5 1 1]);
objs(19) = scicos_link(from=[ 5 1 0], to=[ 6 1 1]);
objs(20) = scicos_link(from=[ 7 1 0], to=[ 8 1 1]);
objs(21) = scicos_link(from=[ 8 1 0], to=[ 9 1 1]);
objs(22) = scicos_link(from=[10 1 0], to=[11 1 1]);
objs(23) = scicos_link(from=[11 1 0], to=[12 1 1]);

scs_m = scicos_diagram(props=props, objs=objs);

// V_in size feat simulation final time and asked values
V_in = struct("time", (0:0.5:5000)', "values", rand(10001, 1));
scicos_simulate(scs_m, list());
assert_checkequal(V_in.time,   V_out_zero.time);
assert_checkequal(V_in.values, V_out_zero.values);
assert_checkequal(V_in.time,   V_out_hold.time);
assert_checkequal(V_in.values, V_out_hold.values);
assert_checkequal(V_in.time,   V_out_repeat.time);
assert_checkequal(V_in.values, V_out_repeat.values);

// V_in is shorter than simulation time
V_in = struct("time", (0:0.5:1000)', "values", rand(2001, 1));
scicos_simulate(scs_m, list());
assert_checkequal(V_in.time,   V_out_zero.time(1:2001));
assert_checkequal(V_in.values, V_out_zero.values(1:2001));
assert_checkequal(V_out_zero.values(2002:10001), zeros(10001 - 2002 + 1, 1));
assert_checkequal(V_in.time,   V_out_hold.time(1:2001));
assert_checkequal(V_in.values, V_out_hold.values(1:2001));
assert_checkequal(V_out_hold.values(2002:10001), ones(10001 - 2002 + 1, 1).*V_in.values($));
assert_checkequal(V_in.time,   V_out_repeat.time(1:2001));
assert_checkequal(V_in.values, V_out_repeat.values(1:2001));
//assert_checkequal(V_in.values, V_out_repeat.values(2002:4002));
