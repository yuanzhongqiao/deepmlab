// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 12747 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12747
//
// <-- Short Description -->
//    The legendre function did not manage the -1 and 1 values for the third 
//    argument.
// =============================================================================

res = legendre(2,2,-1);
assert_checkequal(res, 0);

res = legendre(0, 0:2, [1 -1]);
expected = [1 1;0 0;0 0];
assert_checkequal(res, expected);
