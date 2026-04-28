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
// <-- Non-regression test for bug 16263 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16263
//
// <-- Short Description -->
// Polynomial insertion is broken for complex case

num = [1 1+%i %i+%s];
num(1) = 1;
assert_checkfalse(isreal(num))