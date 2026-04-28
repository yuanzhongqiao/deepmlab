// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- XCOS TEST -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 13059 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13059
//
// <-- Short Description -->
// '%nan' propagated at startup fail the simulation

loadXcosLibs();

assert_checktrue(importXcosDiagram(SCI + "/modules/xcos/tests/nonreg_tests/bug_13059.zcos"));

// check using scicos_simulate
scicos_simulate(scs_m);

A.values
assert_checkequal(A.values, %nan);
clear A;

// check using xcos_simulate
xcos_simulate(scs_m, 4);

assert_checkequal(A.values, %nan);
clear A;

