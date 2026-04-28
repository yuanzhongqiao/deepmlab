// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16559 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16559
//
// <-- Short Description -->
// A(:,:) is empty for sparse matrix of dimension 2^16 or larger

n = 2^16;
A = speye(n,n);
assert_checkequal(size(A,"*"),n*n);
assert_checkfalse(isempty(A));