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
// <-- Non-regression test for bug 14824 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14824
//
// <-- Short Description -->
// Incorrect error message with mfprintf(fd, "%d", [])

fd = mopen(fullfile(TMPDIR, "bug_14824.tmp"), "w");
str = "mfprintf(fd, ""%d"", [])";
assert_checkfalse(execstr(str   ,"errcatch") == 0);
refMsg = msprintf(_("%s: Wrong number of input arguments: data doesn''t fit with format.\n"), "mfprintf");
assert_checkerror(str, refMsg);
mclose(fd)
