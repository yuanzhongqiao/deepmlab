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
// <-- Non-regression test for bug 15808 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15808
//
// <-- Short Description -->
// [5i] is parsed as [5,i]

clear e
assert_checkerror("5e",["5e";"^~^";"Error: 1.1->1.3 Can''t convert ''5e'' to a valid number nor identifier"])
assert_checkerror("[5e]",["[5e]";" ^~^";"Error: 1.2->1.4 Can''t convert ''5e'' to a valid number nor identifier"])
assert_checkerror(".5e",[".5e";"^~~^";"Error: 1.1->1.4 Can''t convert ''.5e'' to a valid number nor identifier"])
assert_checkerror("[.5e]",["[.5e]";" ^~~^";"Error: 1.2->1.5 Can''t convert ''.5e'' to a valid number nor identifier"])
assert_checkerror("5en",["5en";"^~~^";"Error: 1.1->1.4 Can''t convert ''5en'' to a valid number nor identifier"])
assert_checkerror("[5en]",["[5en]";" ^~~^";"Error: 1.2->1.5 Can''t convert ''5en'' to a valid number nor identifier"])
assert_checkerror("[5 e]","Undefined variable: e")
assert_checkerror("[5,e]","Undefined variable: e")
e = 1
assert_checkequal([5e1],[50])
assert_checkequal([5 e],[5,1])
assert_checkequal([5,e],[5,1]) 
