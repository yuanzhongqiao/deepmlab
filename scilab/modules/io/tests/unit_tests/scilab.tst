// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// Test arguments errors
assert_checkerror("scilab(code=""1+1"", file=""test.sci"")", sprintf(_("%s: Wrong input arguments: ''code'' and ''file'' cannot be both provided.\n"), "scilab"));
assert_checkerror("scilab()", sprintf(_("%s: Wrong input arguments: ''code'' or ''file'' must be provided.\n"), "scilab"));
assert_checkerror("scilab(file=""TMPDIR/test.sci"")", sprintf(_("%s: Wrong value for ''%s'' input argument: an existing file ""%s"" expected.\n"), "scilab", "file", "TMPDIR/test.sci"));
assert_checkerror("scilab(code=""1+1"", mode=12)", sprintf(_("%s: Wrong value for ''%s'' input argument: must be in the set {%s}.\n"), "scilab", "mode", "''nw'', ''nwni''"));
assert_checkerror("scilab(code=""1+1"", quit=12)", sprintf(_("%s: Wrong type for ''%s'' input argument: a boolean expected.\n"), "scilab", "quit"));
assert_checkerror("scilab(code=""1+1"", background=12)", sprintf(_("%s: Wrong type for ''%s'' input argument: a boolean expected.\n"), "scilab", "background"));
assert_checkerror("[a, b, c] = scilab(code=""1+1"", background=%T)", sprintf(_("%s: Wrong number of output argument(s): %d expected.\n"), "scilab", 0));

// Test code execution
[status, stdout, stderr] = scilab(code="1+1");
assert_checkequal(status, 0);
stdout(find(stdout == "")) = [];
assert_checkequal(stdout(($-1):$), [" ans = ";"   2."]);
stderr(find(stderr == "")) = [];
assert_checkequal(stderr, []);

// Test file execution
tmp = tempname();
mputl("1+1", tmp);
[status, stdout, stderr] = scilab(file=tmp);
assert_checkequal(status, 0);
stdout(find(stdout == "")) = [];
stdout(grep(stdout, "vm3dgl: ")) = []; // Ignore some warnings (when run in VMware environment)
assert_checkequal(stdout, []);
stderr(find(stderr == "")) = [];
assert_checkequal(stderr, []);
