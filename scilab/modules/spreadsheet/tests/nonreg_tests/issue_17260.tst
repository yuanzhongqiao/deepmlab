// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17260 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17260
//
// <-- Short Description -->
// detectImportOptions failed with .TXT files.

M = ["Var1 Var2 Var3"; "1 2 3"; "4 5 6"; "7 8 9"];
fd = mopen(fullfile(TMPDIR, "issue_17260.TXT"), "wt");
mputl(M, fd);
mclose(fd);

opts = detectImportOptions(fullfile(TMPDIR, "issue_17260.TXT"));
assert_checktrue(opts <> []);