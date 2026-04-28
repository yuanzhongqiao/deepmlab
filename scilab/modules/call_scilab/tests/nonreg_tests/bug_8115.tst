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
// <-- Non-regression test for bug 8115 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8115
//
// <-- Short Description -->
// DisableInteractiveMode did not work

exec("SCI/modules/call_scilab/tests/unit_tests/compileHelpers.sce");

// Define Variables as decribed in the Makefile
// make bug_8115
// ./bug_8115

cflags = struct(getos(), "-I" + SCI + "/modules/ast/includes/system_env", "Windows", "");
ldflags = struct(getos(), "-lsciast", "Windows", "");
[status, stdout, stderr] = run_executable(compile_executable("SCI/modules/call_scilab/tests/nonreg_tests/bug_8115.c", cflags, ldflags));
assert_checkequal(stderr, "");
assert_checkequal(status, 0);
