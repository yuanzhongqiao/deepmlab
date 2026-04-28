// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2017 - Scilab Enterprises - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- WINDOWS ONLY -->
//
// <-- Non-regression test for bug 14909 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14909
//
// <-- Short Description -->
// getlongpathname and getshortpathname must return value with "\" instead of "/"

p = getlongpathname(SCI);
assert_checkequal(grep(p, "/"), []);

p = getshortpathname(WSCI);
assert_checkequal(grep(p, "/"), []);

