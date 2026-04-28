// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 16459 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16459
//
// <-- Short Description -->
// The display of one column hypermatrix is wrong

matrix(1:8, [1,1,2,2,2])
cat(4,4,5)