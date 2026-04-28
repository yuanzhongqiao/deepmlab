// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Sylvestre LEDRU
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- Non-regression test for bug 1969 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/1969
//
// <-- NO CHECK REF -->
// <-- CLI SHELL MODE -->
// <-- UNIX ONLY -->
//
// <-- Short Description -->
// Bad exec was causing a seg fault of Scilab

s=grand(500,1,"nor",0,1)';
a=msprintf("%2.5f ",s');

// cat will exit in error
// scilab must not crash
stat = host("cat "+a+" > /dev/null 2>&1");
assert_checkfalse(stat == 0);
