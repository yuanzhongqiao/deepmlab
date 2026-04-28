// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 12275 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12275
//
// msprintf("%s",ascii(97*ones(1,4097))) yielded "An error occurred: Buffer too small."

a = msprintf("%s",ascii(97*ones(1,4097)));
assert_checkequal(size(a), [1 1]);
assert_checkequal(ascii(a), ones(1,4097)*97);
