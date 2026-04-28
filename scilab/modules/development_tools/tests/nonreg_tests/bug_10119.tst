// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Michael Baudin
// Copyright (C) 2019 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 10119 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/10119
//
// <-- Short Description -->
// assert_checkequal does not support sparse complex doubles

value = sprand(100, 100, 0.01) + sprand(100, 100, 0.01) * %i;
assert_checkequal(value, value);
