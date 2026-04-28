/ =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- XCOS TEST -->
//
// <-- Non-regression test for bug 8884 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8884
//
// <-- Short Description -->
// Region to superblock does not reconstruct 2 links
// from the same starting point but only one.

xcos(SCI + "/modules/xcos/tests/nonreg_tests/bug_8884.zcos");
// Follow diagram labels



