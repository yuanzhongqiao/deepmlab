// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Scilab Enterprises - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 14527 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14527
//
// <-- Short Description -->
//    Calling pathconvert function without parameters crashed Scilab.
// =============================================================================

assert_checkfalse(execstr("pathconvert()"   ,"errcatch") == 0);
refMsg = msprintf(_("%s: Wrong number of input arguments: %d to %d expected.\n"), "pathconvert", 1, 4);
assert_checkerror("pathconvert()", refMsg);
