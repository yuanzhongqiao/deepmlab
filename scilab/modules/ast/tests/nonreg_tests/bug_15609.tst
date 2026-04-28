// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15609 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15609
//
// <-- Short Description -->
// (1:1):2 crashes Scilab (regression)

msg = sprintf(_("%ls: Too many %ls or wrong type for argument %d: Real scalar expected.\n"), "'':''", "'':''", 1);
assert_checkerror("(1:1):2", msg);
assert_checkerror("1:2:3:4", msg);
assert_checkerror("(1:2:3):4", msg);

ref = _("%ls: Wrong type for argument %d: Real scalar expected.\n");
msg = sprintf(ref, "'':''", 1);
assert_checkerror("[1 2 3]:4", msg);

msg = sprintf(ref, "'':''", 2);
assert_checkerror("1:[2 3]", msg);
assert_checkerror("1:[2 3]:4", msg);
assert_checkerror("1:(2:3)", msg);
assert_checkerror("1:(2:3):4", msg);

msg = sprintf(ref, "'':''", 3);
assert_checkerror("1:2:(3:4)", msg);
assert_checkerror("1:2:[3 4]", msg);
