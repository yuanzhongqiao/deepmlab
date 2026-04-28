// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 4759 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4759
//
// <-- Short Description -->
// We should provide a better error message in nlev when called with no input argument

assert_checkfalse(execstr("nlev()"   ,"errcatch") == 0);
refMsg = msprintf(_("%s: Wrong number of input arguments: %d to %d expected.\n"), "nlev", 2, 3);
assert_checkerror("nlev()", refMsg);

