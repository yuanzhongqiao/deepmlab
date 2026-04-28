// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 15736 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15736
//
// <-- Short Description -->
// unique failed with complex numbers.

assert_checkequal(unique([%i 1]),[1 %i]);

// Much more tests in unique.tst
