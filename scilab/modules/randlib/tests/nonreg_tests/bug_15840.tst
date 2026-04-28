// ===================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// ===================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15840 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15840
//
// <-- Short Description -->
// grand(1,"prm",m) yields an unsqueezed size([size(m) 1]) hypermatrix (Regression)
m = rand(2,3);
m = grand(1,"prm",m);
assert_checkequal(ndims(m),2);
assert_checkequal(size(m),[2 3]);