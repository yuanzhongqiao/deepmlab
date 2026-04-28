// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
// Copyright (C) 2015 - Scilab-Enterprises - Cedric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 7601 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7601
//
// <-- Short Description -->
// call_scilab C functions did not check if engine is started.

exec("SCI/modules/call_scilab/tests/unit_tests/compileHelpers.sce");

// Define Variables as decribed in the Makefile
// make bug_7601
// ./bug_7601

[status, stdout, stderr] = run_executable(compile_executable("SCI/modules/call_scilab/tests/nonreg_tests/bug_7601.c"));
assert_checkequal(stderr, "SendScilabJob: call_scilab engine is not started.");
assert_checkfalse(status == 0);
assert_checkequal(stdout($), "  -42.   42.");
