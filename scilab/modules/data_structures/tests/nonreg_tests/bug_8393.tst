// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 8393 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8393
//
// <-- Short Description -->
// definedfields() reported void fields as existing

L = list(%pi,,%z,);
assert_checkequal(definedfields(L), [1 3])
v = L(2);
assert_checkfalse(isdef("v","local"));
v = L(4);
assert_checkfalse(isdef("v","local"));
clear L
L = list();
L(10) = 4;
assert_checkequal(definedfields(L), 10);
