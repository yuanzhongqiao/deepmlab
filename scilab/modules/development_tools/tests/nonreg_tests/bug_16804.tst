// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2021 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16804 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16804
//
// <-- Short Description -->
// [b, m] = assert_checkequal(5, %z) yielded an error instead of just
//          returning the message in m.

err = execstr("[b, m] = assert_checkequal(5, %z)", "errcatch");
assert_checktrue(~err);
assert_checkfalse(b);
assert_checktrue(m<>"");

clear b m
err = execstr("[b, m] = assert_checkequal(5, [3 4])", "errcatch");
assert_checktrue(~err);
assert_checkfalse(b);
assert_checktrue(m<>"");

clear b m
err = execstr("[b, m] = assert_checkequal(1, 1+0*%i)", "errcatch");
assert_checktrue(~err);
assert_checkfalse(b);
assert_checktrue(m<>"");

clear b m
err = execstr("[b, m] = assert_checkequal(1+0*%i, 1)", "errcatch");
assert_checktrue(~err);
assert_checkfalse(b);
assert_checktrue(m<>"");
