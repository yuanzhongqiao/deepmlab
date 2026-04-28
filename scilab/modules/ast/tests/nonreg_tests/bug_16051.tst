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
// <-- Non-regression test for bug 16051 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16051
//
// <-- Short Description -->
// undefined list elements can be of 2 distinct typeof "void" or "listundefined" according to the way they are created

L = list(,);
L(4) = 1;
assert_checkequal(type(L(1)), 0)
assert_checkequal(type(L(3)), 0)
assert_checkequal(typeof(L(1)), "void")
assert_checkequal(typeof(L(3)), "void")
