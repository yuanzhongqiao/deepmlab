// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17391 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17391
//
// <-- Short Description -->
// csvRead extremly slow to detect errors in column structure
filename = fullfile(SCI, "modules", "spreadsheet", "tests", "nonreg_tests", "wrong_multiline_string.csv");
tic();
errmsg = msprintf("%s: can not read file, error in the column structure.\n", "csvRead");
assert_checkerror("csvRead(filename, "","","""",""double"");", errmsg);
t=toc()
assert_checkfalse(t > 60);
