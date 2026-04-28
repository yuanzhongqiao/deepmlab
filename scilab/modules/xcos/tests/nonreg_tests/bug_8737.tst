// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- XCOS TEST -->
//
// <-- Non-regression test for bug 8737 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8737
//
// <-- Short Description -->
// Hidden links should not be ordered when exported

status = importXcosDiagram(SCI + "/modules/xcos/tests/nonreg_tests/bug_8737.zcos");
if ~status then pause, end

// compile and simulate
scicos_simulate(scs_m, list(), struct(), "nw");

