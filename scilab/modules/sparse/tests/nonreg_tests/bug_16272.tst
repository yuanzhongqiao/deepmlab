// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16272 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16272
//
// <-- Short Description -->
// spzeros(0,n) <> sparse([]) and spzeros(n,0) <> sparse([])

assert_checkequal(spzeros(0,5),sparse([]))
assert_checkequal(spzeros(5,0),sparse([]))
