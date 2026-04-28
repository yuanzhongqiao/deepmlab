// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) Scilab Enterprises - 2012 - Simon MARCHETTO
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 9935 -->
//
// <-- CLI SHELL MODE -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9935
//
// <-- Short Description -->
// clear() did not clear all variables

%helps = "toto";
clear()
assert_checkequal(isdef('%helps'), %f);

%helps = "toto";
clear('%helps');
assert_checkequal(isdef('%helps'), %f);
