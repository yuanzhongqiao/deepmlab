// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16865 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16865
//
// <-- Short Description -->
// When m is a non-scalar vector, m(hypermat_of_indices) has not the size of hypermat_of_indices

x=ones(1,3);
y=x';
i=ones(1,2,2);
j=ones(1,2);
assert_checkequal(size(x(i)),[1 2 2])
assert_checkequal(size(y(i)),[1 2 2])
assert_checkequal(size(x(j)),[1 2])
assert_checkequal(size(y(j)),[2 1])
