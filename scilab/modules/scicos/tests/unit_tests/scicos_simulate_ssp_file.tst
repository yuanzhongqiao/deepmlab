// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// Check MVC object leaks on a Scilab simulation.

loadXcosLibs();

scs_m = scicos_diagram();
scs_m.props.tf = 0.5;

scs_m.objs(1) = GENSIN_f("define");
scs_m.objs(1).graphics.pout = 5;
scs_m.objs(2) = GAINBLK("define");
scs_m.objs(2).graphics.pin = 5;
scs_m.objs(2).graphics.pout = 6;
scs_m.objs(3) = TRASH_f("define");
scs_m.objs(3).graphics.pin = 6;
scs_m.objs(3).graphics.pein = 7;
scs_m.objs(4) = CLOCK_c("define");
scs_m.objs(4).graphics.peout = 7;

scs_m.objs(5) = scicos_link(from=[1 1 0], to=[2 1 1]);
scs_m.objs(6) = scicos_link(from=[2 1 0], to=[3 1 1]);
scs_m.objs(7) = scicos_link(from=[4 1 0], to=[3 1 1], ct=[1 -1]);

fname = fullfile(TMPDIR, "scicos_simulate_ssp_file.ssp");
scicosDiagramToScilab(fname, scs_m);
disp(decompress(fname, TMPDIR))

// load it back
scs_m_ssp = scicosDiagramToScilab(fname);

// ensure both files simulate
Info1 = scicos_simulate(scs_m, list());
Info2 = scicos_simulate(scs_m_ssp, list());

// check that simulation informations are the same
assert_checktrue(Info1(2).sim == Info2(2).sim)
