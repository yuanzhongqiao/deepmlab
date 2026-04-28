// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Clement DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- XCOS TEST -->

// <-- ENGLISH IMPOSED -->

// <-- Non-regression test for bug 12384 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12384
//
// <-- Short Description -->
// Algebraic loop error while compiling a diagram with a modelica part linked
// to another modelica part with an explicit link (using a sensor).

ilib_verbose(0);

importXcosDiagram(SCI+"/modules/xcos/tests/nonreg_tests/bug_12384.zcos");
Info = scicos_simulate(scs_m,list());

