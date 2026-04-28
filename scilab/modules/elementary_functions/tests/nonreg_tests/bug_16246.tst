// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 16246 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16246
//
// <-- Short Description -->
// isvector(sparse([1 2])) returns %F  (6.0 Regression)

assert_checktrue(isvector(sparse([1 2])));
assert_checktrue(isvector(sparse([1 2]')));
assert_checkfalse(isvector(sparse([1 2;3 4])));
