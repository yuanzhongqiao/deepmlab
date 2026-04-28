// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 13839 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13839
//
// <-- Short Description -->
//    sign() did not accept sparse matrices
m = sprand(100,10,0.007);
i = find(m~=0 & m<0.5);
m(i) = m(i)-0.5;
err = execstr("sign(m);", "errcatch");
assert_checkequal(err, 0);
err = execstr("sign(m+%i*m);", "errcatch");
assert_checkequal(err, 0);
