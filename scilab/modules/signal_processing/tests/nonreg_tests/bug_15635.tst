// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- ENGLISH IMPOSED -->
//
// <-- Non-regression test for bug 15635 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15635
//
// <-- Short Description -->
// delip(1,4) terminates with neither output nor error (regression)

errMsg=sprintf(_('%s: Wrong value for input argument #%d: Must be in the interval [%d, %d].\n'), "delip", 2, -1, 1);
assert_checkerror('delip(1,4)',errMsg);
