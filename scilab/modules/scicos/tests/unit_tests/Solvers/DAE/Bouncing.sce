// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

scs_m = scicos_diagram(version=get_scicos_version());
scs_m.props.tol = [1.000D-10, 1.000D-10, 1.000D-10, 100001, 0, 101, 0];
scs_m.props.tf = 50;
scs_m.props.context = "per = 0.005;";

clk = CLOCK_f("define");
clk.model.rpar.objs(2).graphics.exprs = ["per" ; "0"];

bounce = MBLOCK("define");
bounce.model.in = [];
bounce.model.in2 = [];
bounce.model.intyp = [];
bounce.model.out = [1;1];
bounce.model.out2 = [1;1];
bounce.model.outtyp = [1;1];
bounce.model.equations.model = 'Bounce';
bounce.graphics.exprs.in = '';
bounce.graphics.exprs.intype = '';
bounce.graphics.exprs.out = '[''y'';''v'']';
bounce.graphics.exprs.outtype = '[''E'';''E'']';
bounce.graphics.exprs.param = '[''g'';''k'']';
bounce.graphics.exprs.paramv = list("0.9","0.8");
bounce.graphics.exprs.pprop = '[0;0]';
bounce.graphics.exprs.nameF = 'Bounce';
bounce.graphics.exprs.funtxt = ["class Bounce"
  " parameter Real g=9.8;"
  " parameter Real k=1;"
  " Real y(start=10),v(start=3); "
  "equation"
  " der(y)=v;"
  " der(v)=-g;"
  " when y<0 then "
  " reinit(v,-k*v);"
  " end when;"
  "end Bounce;"];

tows = TOWS_c("define");
tows.graphics.exprs = ["500";"res";"0"];

lnk1 = scicos_link(from=[2 1 0], to=[3 1 1]);
lnk2 = scicos_link(from=[1 1 0], to=[3 1 1], ct=[1 -1]);

scs_m.objs = list(clk, bounce, tows, lnk1, lnk2);

// refresh the model
needcompile = 4;
%scicos_context = script2var(scs_m.props.context, struct());
scs_m = do_eval(scs_m, list(), %scicos_context);
