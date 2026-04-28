// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2014 - Scilab Enterprises - Paul Bignier
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 13511 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13511
//
// <-- Short Description -->
// lcm used with doubles returned wrong type values,
// bezout help did not mention doubles.

assert_checkequal(lcm([96 6250 10000 18700]), 56100000);

[P, U] = bezout(3.5, 4.2);
assert_checkequal(coeff(P), 1);
assert_checkalmostequal(clean(coeff(U)), [0 4.2; 1/4.2 -3.5]);
