// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- XCOS TEST -->
//
// <-- Non-regression test for bug 8483 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8483
//
// <-- Short Description -->
// MATMUL did not work for vectors

importXcosDiagram(SCI + "/modules/xcos/tests/nonreg_tests/bug_8483.zcos");
xcos_simulate(scs_m, 4);

if or(3 * A.values <> B.values) then pause, end
