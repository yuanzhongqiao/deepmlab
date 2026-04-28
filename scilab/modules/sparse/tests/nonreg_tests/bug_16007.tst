// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16007 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16007
//
// <-- Short Description -->
// non-integer index in sparse makes Scilab crash

A=sparse([1 1.5], 1);
assert_checkerror("sparse([1 0.5], 1)",sprintf(_("%s: Invalid index.\n"),"sparse"));