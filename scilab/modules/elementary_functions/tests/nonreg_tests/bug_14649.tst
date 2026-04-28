// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 14649 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14649
//
// <-- Short Description -->
//  isnan(complex(%inf, %inf)) returned %F

C = complex([-%inf -%inf %inf %inf], [-%inf %inf -%inf %inf]);
res = [%t %t %t %t];
assert_checkequal(isnan(C), res);
assert_checkequal(isnan(sparse(C)), sparse(res));
