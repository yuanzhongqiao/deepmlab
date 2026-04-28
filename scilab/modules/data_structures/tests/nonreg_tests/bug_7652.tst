// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2017 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 7652 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7652
//
// <-- Short Description -->
// Inserting list("") in a cells array could be erroneous

c = cell(2,2);
c(2,2) = {list("")};
assert_checkequal(c{2,2}, list(""));
c(2,2) = {list([])};
assert_checkequal(c{2,2}, list([]));
c(2,2) = {list()};
assert_checkequal(c{2,2}, list());

c{2,2} = list("");
assert_checkequal(c{2,2}, list(""));
c{2,2} = list([]);
assert_checkequal(c{2,2}, list([]));
c{2,2} = list();
assert_checkequal(c{2,2}, list());
