// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Scilab Enterprises - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 13620 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13620
//
// <-- Short Description -->
//    dos function called with a vector as input crashed.
// =============================================================================

assert_checkfalse(execstr("host([""dir"", ""dir""])", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong size for input argument #%d: string expected.\n"), "host", 1);
assert_checkerror("host([""dir"", ""dir""])", refMsg);

assert_checkfalse(execstr("host([""dir""; ""dir""])", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong size for input argument #%d: string expected.\n"), "host", 1);
assert_checkerror("host([""dir"", ""dir""])", refMsg);
