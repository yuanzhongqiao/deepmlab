// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 7291 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7291
//
// <-- Short Description -->
// unix('') and dos('') returned a wrong messsage in console

r = host('');
assert_checkequal(r, 0);

[r, o, e] = host('');
assert_checkequal(r, 0);
assert_checkequal(o, "");
assert_checkequal(e, "");

r = host('', echo=%t);
assert_checkequal(r, 0);
assert_checkequal(o, "");
assert_checkequal(e, "");
