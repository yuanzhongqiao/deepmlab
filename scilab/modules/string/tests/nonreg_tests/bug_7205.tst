// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2014 - Scilab Enterprises - Charlotte HECQUET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 7205 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7205
//
// <-- Short Description -->
// length() applied to a non string hypermatrix returns 3 instead size(H,"*")
//

A=rand(2,2,2,2);
assert_checkequal(length(A), size(A, "*"));
A=rand(5,5,5,5,5,5,5);
assert_checkequal(length(A), size(A, "*"));
