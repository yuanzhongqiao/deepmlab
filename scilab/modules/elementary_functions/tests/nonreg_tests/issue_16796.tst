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
// <-- Non-regression test for bug 16796 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16796
//
// <-- Short Description -->
// isreal(complex(1,%nan),0) returns %T instead of %F (Scilab 6.0.0 regression)

a = 1+imult(%nan);
x(2) = a;
p = %s + a;

assert_checkfalse(isreal(a,0))
assert_checkfalse(isreal(x,0))
assert_checkfalse(isreal(p,0))