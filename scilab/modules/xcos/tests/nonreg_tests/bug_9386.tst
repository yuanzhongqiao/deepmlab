// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- XCOS TEST -->
// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for bug 9386 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9386
//
// <-- Short Description -->
// Diagram root cell might be invalid on hierarchical diagrams.

xcos(SCI + "/modules/xcos/tests/nonreg_tests/bug_9386.zcos");
// Open the superblock

