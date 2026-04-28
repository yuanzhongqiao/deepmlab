// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008-2008 - DIGITEO - Simon LIPP <simon.lipp@inria.fr>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 3462 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3462
//

// <-- Short Description -->
//   The match string returned by regexp is not the right one if the subject
//   string contains backslashes.

assert_checkequal(regexp("\n", "/n/"), 2);
assert_checkequal(regexp("\>15Hello, world.", "/world/"), 12);

[start, final, match] = regexp("/usr\local/en_US","/([a-z][a-z]_[A-Z][A-Z])$/");
assert_checkequal(start, 12);
assert_checkequal(final, 16);
assert_checkequal(match, "en_US");