// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Charlotte HECQUET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 8234 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8234
//
// <-- Short Description -->
// strtod should return an empty matrix when input argument is an empty matrix

[d, str] = strtod([]);
assert_checkequal(d, []);
assert_checkequal(str, "");
