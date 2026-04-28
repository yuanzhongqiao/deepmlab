// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15746 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15746
//
// <-- Short Description -->
// 1/[1 2 3] and [1 2 3]'\1 should raise an error

B=1;
A=[1 2 3];
msg = msprintf(_("Operator %ls: Wrong dimensions for operation [%ls] %ls [%ls], same number of columns expected.\n"), "/", "1x1", "/", "1x3");
assert_checkerror("B/A", msg);
A=A';
assert_checkalmostequal((B/A)*A,B);
msg = msprintf(_("Operator %ls: Wrong dimensions for operation [%ls] %ls [%ls], same number of rows expected.\n"), "\", "3x1", "\", "1x1");
assert_checkerror("A\B", msg);
A=A';
assert_checkalmostequal(A*(A\B),B);

