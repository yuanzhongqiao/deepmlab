// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 8301 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8301

//
// <-- Short Description -->
// definedfields() reported void fields in mlist or tlist, as defined

T = tlist(["test" "txt" "real" "bool"],"Hi",,%T);
assert_checkequal(definedfields(T), [1 2 4]);

M = mlist(["test" "txt" "real" "bool"],"Hi",,%T);
assert_checkequal(definedfields(M), [1 2 4]);
