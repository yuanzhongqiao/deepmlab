// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- NOT FIXED -->
//
// <-- Non-regression test for bug 11394 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/11394
//
// <-- Short Description -->
// In call_scilab, TerminateScilab did not allow a restart in NW mode.

exec("SCI/modules/call_scilab/tests/unit_tests/compileHelpers.sce");

// Define Variables as decribed in the Makefile
// make bug_11394
// ./bug_11394

[status, stdout, stderr] = run_executable(compile_executable("SCI/modules/call_scilab/tests/nonreg_tests/bug_11394.c"));
assert_checkequal(stderr, "");
assert_checkequal(status, 0);
