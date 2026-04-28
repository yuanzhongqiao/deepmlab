// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - Scilab Enterprises - Cedric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 15557 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15557
//
// <-- Short Description -->
// mtlb_std called with only one argument returns an error

X = rand(1:10);
assert_checkequal(mtlb_std(X), mtlb_std(X, 0, "*"))
