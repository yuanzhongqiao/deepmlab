// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- ENGLISH IMPOSED -->
// <-- NO CHECK REF -->
// <-- NOT FIXED --> Scilab 2026.0 have a Sundials h_min error
//
// <-- CLI SHELL MODE -->
//

loadXcosLibs();
scs_m = scicos_diagram();

continuous_sinus = CLSS("define");
continuous_sinus.graphics.exprs = ["[0 1; -1 0]";"[]";"[1 0]";"[]";"[1 0]"];
scs_m.objs(1) = continuous_sinus;

scs_m.props.tol(6) = 0;
Info = scicos_simulate(scs_m, list(), 'nw');

scs_m.props.tol(6) = 1;
scicos_simulate(scs_m, Info, 'nw');

scs_m.props.tol(6) = 2;
scicos_simulate(scs_m, Info, 'nw');

scs_m.props.tol(6) = 3;
scicos_simulate(scs_m, Info, 'nw');

scs_m.props.tol(6) = 4;
scicos_simulate(scs_m, Info, 'nw');

scs_m.props.tol(6) = 5;
scicos_simulate(scs_m, Info, 'nw');

scs_m.props.tol(6) = 6;
scicos_simulate(scs_m, Info, 'nw');

scs_m.props.tol(6) = 7;
scicos_simulate(scs_m, Info, 'nw');

scs_m.props.tol(6) = 8;
scicos_simulate(scs_m, Info, 'nw');

scs_m.props.tol(6) = 100;
scicos_simulate(scs_m, Info, 'nw');

scs_m.props.tol(6) = 101;
scicos_simulate(scs_m, Info, 'nw');

scs_m.props.tol(6) = 102;
scicos_simulate(scs_m, Info, 'nw');
