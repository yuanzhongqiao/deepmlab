// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16200 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16200
//
// <-- Short Description -->
// Concatenation of transposed cells crashes Scilab

c = {1,2}
assert_checkequal([c', c'],{1,1;2,2})

