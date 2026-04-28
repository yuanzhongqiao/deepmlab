// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - Scilab Enterprises - Sylvestre Ledru
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 10564 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/10564
//
// <-- Short Description -->
// linspace was too agressive on input argument checks
//
a=ones(0:3.3);
assert_checkequal(a,[1,1,1,1]);
a=ones(0:3.1);
assert_checkequal(a,[1,1,1,1]);
a=ones(0:3.9);
assert_checkequal(a,[1,1,1,1]);
a=ones(0:3.1);
assert_checkequal(a,[1,1,1,1]);
a=ones(0:4);
assert_checkequal(a,[1,1,1,1,1]);
assert_checkequal(linspace([0;2],[2;5],2),[0,2;2,5]);

