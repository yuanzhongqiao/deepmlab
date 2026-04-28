// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - Nimish Kapoor
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15142 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15142
//
// <-- Short Description -->
// mopen(): wrong err value

[fd, err] = mopen('fake-file.txt', 'r')
assert_checkequal(err,-2);