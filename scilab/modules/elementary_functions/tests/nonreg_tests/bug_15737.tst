// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 15737 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15737
//
// <-- Short Description -->
// setdiff() was wrong for complex numbers.

assert_checkequal(setdiff([1+%i 1-%i],1-%i), 1+%i);
assert_checkequal(setdiff(1-%i, [1-%i 1+%i]), []);
