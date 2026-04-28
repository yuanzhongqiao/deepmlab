// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

exec("SCI/modules/call_scilab/tests/unit_tests/compileHelpers.sce");

[status, stdout, stderr] = run_executable(compile_executable("SCI/modules/call_scilab/examples/basicExamples/readwriteboolean.c"));
assert_checkequal(stderr, "");
assert_checkequal(status, 0);
