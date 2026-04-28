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
// <-- Non-regression test for bug 16085 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16085
//
// <-- Short Description -->
// insertion in an empty struct is broken (regression)

x=struct();
y.b = 1;
y.c = 2;
x(:) = y;

assert_checktrue(isstruct(x));
assert_checkequal(fieldnames(x),["b";"c"])
assert_checkequal(x.b,1);
assert_checkequal(x.c,2);

