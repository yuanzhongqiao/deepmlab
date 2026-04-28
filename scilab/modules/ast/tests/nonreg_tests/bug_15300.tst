// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2017 - ESI - Delamarre Cedric
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15300 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15300
//
// <-- Short Description -->
// Crash when the function name is forgotten!
// Test updated after issue #14372 fix

A=(1,1);
assert_checkequal(A, 1);
