// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15886 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15886
//
// <-- Short Description -->
// display of polynomials is broken

assert_checkequal(string((1-%s)^3),["1 -3s +3s^2 -s^3"]);
