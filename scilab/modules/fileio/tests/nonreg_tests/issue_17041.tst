// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 17041 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17041
//
// <-- Short Description -->
// Wrong error message when calling `mopen` in read mode for a new file.

assert_checkerror("mopen(""test"")", msprintf(_("%s: Cannot open file %s.\n"), "mopen", "test"));

[fd, err]=mopen("test");
assert_checkequal(fd, 0);
assert_checkequal(err, -2);