//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Charlotte HECQUET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 12875 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12875
//
// <-- Short Description -->
// phasemag returns an error for vector containing zero.

assert_checkequal(phasemag([0 0]), [0 0]);
assert_checkequal(phasemag([%i 0]), [90 0]);
assert_checkequal(phasemag([-%i 0]), [-90 0]);
