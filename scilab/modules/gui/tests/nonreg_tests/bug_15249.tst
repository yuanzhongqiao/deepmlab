// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2017 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15249 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15249
//
// <-- Short Description -->
// findobj("toto") yields an error after https://gitlab.com/scilab/scilab/-/issues/7117

clf
refMsg = msprintf(_("%s: Wrong number of input argument(s): At least %d expected.\n"), "findobj", 2);
assert_checkerror("findobj(""toto"")", refMsg);
