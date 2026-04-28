// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - ESI Group - Clement DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 10171 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/10171
//
// <-- Short Description -->
// loadmatfile could not load cells

loadmatfile('SCI/modules/matio/tests/nonreg_tests/bug_10171.mat');
assert_checkequal(typeof(P), "ce");
assert_checkequal(typeof(M), "ce");
assert_checkequal(size(P), [1,11]);
assert_checkequal(size(M), [1,11]);

