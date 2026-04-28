// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

loadXcosLibs();

props = scicos_params(tf=10);

objs = list()
objs(1) = FROMWSB("define");
objs(2) = TRASH_f("define");
objs(2).model.in = 1;
objs(2).model.in2 = 1;
objs(3) = CLOCK_c("define");
objs(4) = scicos_link(from=[1 1 0], to=[2 1 1]);
objs(5) = scicos_link(from=[3 1 0], to=[2 1 1], ct=[1 -1]);

scs_m = scicos_diagram(props=props, objs=objs);

V = struct("time", (1:10)', "values", sin((0:0.1:0.9)'));
scicos_simulate(scs_m, list());


//
// switch all parameters
// 

// look for the internal edge trigger block
ppath = list("objs", 1, "model", "rpar", "objs");
for i=1:length(scs_m(ppath)) do
    ppath_inner = ppath;
    ppath_inner($+1)=i;

    o = scs_m(ppath_inner);
    if typeof(o) == "Block" & o.gui == "FROMWS_c" then
        ppath = ppath_inner;
        break;
    end
end

Variable_name = ["V1" "Vé" "V£" "V在宅"]
Interpolation_method = ["0" "1" "2" "3"]
Use_zero_crossing = ["0" "1"]
Output_at_end = ["0" "1" "2"]

all_params = combinations(Variable_name, Interpolation_method, Use_zero_crossing, Output_at_end);
for params = table2matrix(all_params)' do
    v = params(1);
    execstr(v + " = V;");
    scs_m(ppath).graphics.exprs = params';
    scicos_simulate(scs_m, list());
    clear(v);
end
