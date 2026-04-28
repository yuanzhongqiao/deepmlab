// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 12121 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12121
//
// <-- Short Description -->
//    inv() did not work for complex sparse matrices.
// =============================================================================

A = %i*speye(3,3);
assert_checkequal(inv(A), -A);

A = rand(5,5)*%i;
assert_checkalmostequal(full(inv(sparse(A))), inv(A));
