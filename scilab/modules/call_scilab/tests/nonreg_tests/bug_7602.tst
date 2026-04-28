// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 7602 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7602
//
// <-- Short Description -->
// it was not possible to start/close a Scilab engine at anytime.

exec("SCI/modules/call_scilab/tests/unit_tests/compileHelpers.sce");

// Define Variables as decribed in the Makefile
// make bug_7602
// ./bug_7602

[status, stdout, stderr] = run_executable(compile_executable("SCI/modules/call_scilab/tests/nonreg_tests/bug_7602.c"));
assert_checkequal(stderr, "");
assert_checkequal(status, 0);
output = stdout(find(stdout == "  -42.   42."));
// you must have 10 display of    - 42.    42.
assert_checkequal(size(output, "*"), 10);
assert_checkequal(output(1), "  -42.   42.");
