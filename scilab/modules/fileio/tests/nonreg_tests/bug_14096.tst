// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2015 - Scilab Enterprises - Cedric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 14096 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14096
//
// <-- Short Description -->
// Issue with mscanf Function.

[n,name,fn] = msscanf("Dataset Name:  Gauss2            (Gauss2.dat)","Dataset Name: %s %s");
assert_checkequal(fn, "(Gauss2.dat)");
assert_checkequal(name, "Gauss2");
assert_checkequal(n, 2);
