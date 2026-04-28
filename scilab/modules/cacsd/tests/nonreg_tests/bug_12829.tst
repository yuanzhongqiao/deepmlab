//<-- CLI SHELL MODE -->
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Charlotte HECQUET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 12829 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12829
//
// <-- Short Description -->
// routh_t() function with two input argument (routh_t(h,kp)) gives a wrong table for the special case
// in which the first element of a row is zero.

s=%s;
P=5*s^3-10*s^2+7*s+20;
routh_t((1+s)/P,10);
[r, num]=routh_t(P);
assert_checkequal(num, 2);
