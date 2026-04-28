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
// <-- Non-regression test for bug 16087 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16087
//
// <-- Short Description -->
// Insertion of struct() in a non-empty struct crashes Scilab

x.a = 1;
x.b = 2;
y = x;
x(1) = struct();

assert_checkequal(x,y)

