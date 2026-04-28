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
// <-- Non-regression test for bug 16089 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16089
//
// <-- Short Description -->
// x=1:1e10 freeze Scilab

assert_checkerror("1:1e10",_("Cannot allocate memory"))

