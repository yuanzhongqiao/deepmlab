// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 17022 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17022
//
// <-- Short Description -->
// kroneck() returned wrong error message

assert_checkfalse(execstr("kroneck()"   ,"errcatch") == 0);
refMsg = msprintf(_("%s: Wrong number of input arguments: %d to %d expected.\n"), "kroneck", 1, 2);
assert_checkerror("kroneck()", refMsg);