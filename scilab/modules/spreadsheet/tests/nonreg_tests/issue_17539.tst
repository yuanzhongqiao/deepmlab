// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2026 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17539 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17539
//
// <-- Short Description -->
// detectImportOptions did not detect a column whose variable name is empty

M = ["A", "B", ""; string(ones(3,1) * [1 2 3])];
path = fullfile(TMPDIR, "test.csv");
csvWrite(M, path);
opts = detectImportOptions(path);
assert_checkequal(opts.variableNames, ["A", "B", "Var3"]);
assert_checkequal(opts.delimiter, ",");
t = readtable(path, opts);
assert_checkequal(table2matrix(t), ones(3,1) * [1 2 3]);
