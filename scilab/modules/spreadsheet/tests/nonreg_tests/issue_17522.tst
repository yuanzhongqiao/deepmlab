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
// <-- Non-regression test for issue 17522 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17522
//
// <-- Short Description -->
// substitute option is now managed in csvTextScan function

path = fullfile(SCI, "modules", "spreadsheet", "tests", "nonreg_tests");
m = csvRead(fullfile(path, "issue_17522.txt"), ";", [], "double", [" ; ", ";"]);

l = mgetl(fullfile(path, "issue_17522.txt"));
m2 = csvTextScan(l, ";", [], "double", [" ; ", ";"]);
assert_checktrue(m == m2);
