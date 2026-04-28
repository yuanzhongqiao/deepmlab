// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 17074 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17074
//
// <-- Short Description -->
// write() does not write text-content to the file.

u = mopen("issue_17074.txt", "w");
msg = msprintf(_("%s: Wrong input argument #%d: A file opened using the function ''%s'' expected.\n"), "write", 1, "file")
assert_checkerror("write(u, [""this is first line"";""second line""], ""(a)"");", msg);
