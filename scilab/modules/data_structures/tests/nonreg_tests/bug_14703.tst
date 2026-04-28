// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2017 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 14703 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14703
//
// <-- Short Description -->
// type(linspace) (or other unloaded macros in libs) returned 11 instead of 13

assert_checkequal(type(dec2bin), 13);
assert_checkequal(type(issparse), 13);
