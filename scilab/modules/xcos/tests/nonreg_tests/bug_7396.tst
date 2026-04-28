// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- XCOS TEST -->
//
// <-- Non-regression test for bug 7396 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7396
//
// <-- Short Description -->
// On I/O blocks used in SuperBlocks, empty index throws a decoding exception.

// perform a blocking decode operation
importXcosDiagram(SCI + "/modules/xcos/tests/nonreg_tests/bug_7396.zcos");

