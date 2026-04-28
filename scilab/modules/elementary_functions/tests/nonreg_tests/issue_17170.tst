// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17170 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17170
//
// <-- Short Description -->
// meshgrid incorrect check of output arguments

// Tests with lhs == 0
ierr = execstr("meshgrid(1:2);", "errcatch");
assert_checktrue(ierr == 0);
ierr = execstr("meshgrid(1:2,1:2);", "errcatch");
assert_checktrue(ierr == 0);
ierr = execstr("meshgrid(1:2,1:2);", "errcatch");
assert_checktrue(ierr == 0);

// Test error message with invalid number of outputs
errmsg = msprintf(gettext("%s: Wrong number of output arguments: At most %d expected.\n"),"meshgrid",2);
assert_checkerror("[X,Y,Z] = meshgrid(1:2);", errmsg);
errmsg = msprintf(gettext("%s: Wrong number of output arguments: At most %d expected.\n"),"meshgrid",2);
assert_checkerror("[X,Y,Z] = meshgrid(1:2);", errmsg);
errmsg = msprintf(gettext("%s: Wrong number of output arguments: At most %d expected.\n"),"meshgrid",3);
assert_checkerror("[X,Y,Z,K] = meshgrid(1:2);", errmsg);