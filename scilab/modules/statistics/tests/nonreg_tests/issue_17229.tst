// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17229 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17229
//
// <-- Short Description -->
// nanreglin did not removed all %nan.

x = [1 %nan 3];
y = [2 2 %nan];
[a, b] = nanreglin(x, y);
assert_checkequal(a, 0);
assert_checkequal(b, 2);

x = 0:10;
x(2) = %nan;
y = 20:30;
y(4) = %nan;
[a, b] = nanreglin(x, y);
assert_checkequal(a, 1);
assert_checkequal(b, 20);

c = x(3);
x(3) = %inf;
refMsg = msprintf(_("%s: Wrong value for input argument #%d: Must not contain Inf.\n"), "reglin", 1);
assert_checkerror("[a, b] =  nanreglin(x, y)", refMsg);

x(3) = c;
y(8) = %inf;
refMsg = msprintf(_("%s: Wrong value for input argument #%d: Must not contain Inf.\n"), "reglin", 2);
assert_checkerror("[a, b] =  nanreglin(x, y)", refMsg);