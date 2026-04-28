// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Michael Baudin
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO ASSERT FAILURE -->

// <-- Non-regression test for bug 9635 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9635
//
// <-- Short Description -->
// The default value of comptype in assert_checkalmostequal is wrongly chosen.

A = [1e10 1e-2];
B = [1e10 2e-2];
instr = "assert_checkalmostequal(A,B)";
lclmsg = "%s: Assertion failed: expected(%s) = %s while computed(%s) = %s";
assert_checkerror(instr,lclmsg,[],"assert_checkalmostequal","1,2",string(B(1,2)),"1,2",string(A(1,2)));
