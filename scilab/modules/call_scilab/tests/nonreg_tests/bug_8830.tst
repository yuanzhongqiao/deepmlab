// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Sylvestre LEDRU
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 8830 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8830
//
// <-- Short Description -->
// In call_scilab, TerminateScilab  did not clear the last error.

exec("SCI/modules/call_scilab/tests/unit_tests/compileHelpers.sce");

// Define Variables as decribed in the Makefile
// make bug_8830
// ./bug_8830

[status, stdout, stderr] = run_executable(compile_executable("SCI/modules/call_scilab/tests/nonreg_tests/bug_8830.c"));
assert_checkequal(stderr, "");
assert_checkequal(status, 0);
assert_checkequal(stdout(2), "my own error");
assert_checkequal(stdout(3), "getLastErrorValue 0");
