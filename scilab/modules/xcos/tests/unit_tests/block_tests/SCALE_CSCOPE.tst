// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- ENGLISH IMPOSED -->
// <-- XCOS TEST -->
// <-- NO CHECK REF -->
//
// <-- Unit test for SCALE_CSOPE -->
//
// <-- Short Description -->
// This scope autocompute its visible bounds
//

scs_m = scicos_diagram();

blk1 = RAMP("define");
blk1.graphics.exprs = ["0.1", "2", "-10"];
blk2 = SCALE_CSCOPE("define");
blk3 = CLOCK_c("define");
blk4 = CLINDUMMY_f("define");

lnk1 = scicos_link(from=[1 1 0], to=[2 1 1]);
lnk2 = scicos_link(from=[3 1 0], to=[2 1 1], ct=[1,-1]);

scs_m.objs = list(blk1, blk2, blk3, blk4, lnk1, lnk2);
scicos_simulate(scs_m);
