// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16553 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16553
//
// <-- Short Description -->
// unique(["", "", "", "", ""]) returned [""  ""  ""  ""  ""] instead of ""

assert_checkequal(unique(["" ""]), "");
assert_checkequal(unique(["" "" "" ""]), "");
