// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 7848 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7848
//
// <-- Short Description -->
//    The third argument of correl function is now optional.
// =============================================================================

r = correl(1:10, 1:10);
assert_checkequal(r, 1);

fre = eye(10, 10);
r = correl(1:10, 1:10, fre);
assert_checkequal(r, 1);

fre = ones(10, 10);
r = correl(1:10, 1:10, fre);
assert_checkalmostequal(r, 0, 0, %eps); // test modified after MKL update (oneAPI 2025.2) 

r = correl(1:10, -(1:10));
assert_checkequal(r, -1);

fre = eye(10, 10);
r = correl(1:10, -(1:10), fre);
assert_checkequal(r, -1);

fre = ones(10, 10);
r = correl(1:10, -(1:10), fre);
assert_checkalmostequal(r, 0, 0, %eps); // test modified after MKL update (oneAPI 2025.2) 
