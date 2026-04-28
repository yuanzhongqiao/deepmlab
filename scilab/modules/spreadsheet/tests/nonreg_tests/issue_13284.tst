// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for issue 13284 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13284
//
// <-- Short Description -->
// former read_csv could read different row lengths, csvRead cannot.

[r, header] = csvRead(SCI + "/modules/spreadsheet/tests/nonreg_tests/issue_13284.csv", ",", [], "string", [], [], [], 2);
assert_checkequal(size(header), [2 1]);
assert_checkequal(length(header(1)), 48);
assert_checkequal(length(header(2)), 1071);
assert_checkequal(size(r), [8760 68]);