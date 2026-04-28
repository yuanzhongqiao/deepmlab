// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Michael Baudin
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 9461 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9461
//
// <-- Short Description -->
// The assert_checkalmostequal function does not manage sparse matrices.

A=spzeros(2,2);
B=spzeros(2,2);
assert_checkalmostequal(A,B);

A = zeros(2,3,4);
B = zeros(2,3,4);
assert_checkalmostequal(A,B);

