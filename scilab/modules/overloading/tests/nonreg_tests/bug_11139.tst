//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Charlotte HECQUET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 11139 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/11139
//
// <-- Short Description -->
// conj is not defined for sparse matrices

A=[complex(1,2), complex(2,3); 0, 0];
sp_ref=sparse(conj(A));
sp=conj(sparse(A));
assert_checkequal(sp,sp_ref);
