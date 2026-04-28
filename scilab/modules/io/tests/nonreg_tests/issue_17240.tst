// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
//`unix_g` does not read stderr when exit code is 0 or 1 ; it does not read stdout when exit code is 2 or more

//note: stripblanks is used because echo on Windows will add an extrat space.
[status, stdout, stderr] = host("echo out && echo err 1>&2 && exit 0");
assert_checkequal(status, 0);
assert_checkequal(stripblanks(stdout), "out");
assert_checkequal(stripblanks(stderr), "err");

[status, stdout, stderr] = host("echo out && echo err 1>&2 && exit 1");
assert_checkequal(status, 1);
assert_checkequal(stripblanks(stdout), "out");
assert_checkequal(stripblanks(stderr), "err");

[status, stdout, stderr] = host("echo out && echo err 1>&2 && exit 2");
assert_checkequal(status, 2);
assert_checkequal(stripblanks(stdout), "out");
assert_checkequal(stripblanks(stderr), "err");