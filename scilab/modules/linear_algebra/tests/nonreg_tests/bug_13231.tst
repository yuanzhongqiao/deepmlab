// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- LONG TIME EXECUTION -->

// <-- Non-regression test for bug 13231 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13231
//
// <-- Short Description -->
// spec() yielded a segfault


n = 2000;
A = rand(n,n);
d = spec(A);
[X,D] = spec(A);
