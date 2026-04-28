// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 14216 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14216
//
// <-- Short Description -->
// readxls can make Scilab crash without any error message
//

msg = msprintf(_("%s: Incorrect or corrupted file.\n"), "xls_open");
assert_checkerror("readxls(""SCI/modules/spreadsheet/tests/nonreg_tests/issue_14216.xls"")", msg);
