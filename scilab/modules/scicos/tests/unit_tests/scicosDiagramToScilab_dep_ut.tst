// ============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// ============================================================================

// <-- XCOS TEST -->
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// A mis-saved of the dep_ut Block property make the simulation failed
//

loadXcosLibs()

scs_m = scicos_diagram();
scs_m.props.tf = 0.1
scs_m.objs(1) = INTEGRAL_m("define");
scs_m.objs(2) = scicos_link(from=[1 1 0], to=[1 1 1])

scicos_simulate(scs_m, list());
scicosDiagramToScilab("test_dep_ut_1.ssp", scs_m);
movefile(decompress("test_dep_ut_1.ssp"), "test_dep_ut_1.ssd");

scs_m_1 = scicosDiagramToScilab("test_dep_ut_1.ssp");
scicos_simulate(scs_m_1, list());

scicosDiagramToScilab("test_dep_ut_2.ssp", scs_m_1);
movefile(decompress("test_dep_ut_2.ssp"), "test_dep_ut_2.ssd");

scs_m_2 = scicosDiagramToScilab("test_dep_ut_2.ssp");
scicos_simulate(scs_m_2, list());
