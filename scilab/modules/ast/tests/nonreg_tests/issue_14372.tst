// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 14372-->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14372
//
// <-- Short Description -->
// after L=list(1,"a",%t), a=L(2:3) returns an error.
//

L=list(1,"a",%t,42);

[a, b]=L(2:4);
assert_checkequal(a, "a");
assert_checkequal(b, %t);

a=L(2:4);
assert_checkequal(a, "a");

L(2:4);
assert_checkequal(ans, "a");

msg = msprintf(_("%s: Wrong number of output argument(s): %d expected.\n"), "extract", 0);
assert_checkerror("a=L([])", msg);

function nb_input = checkinput(varargin)
    nb_input = nargin
endfunction

assert_checkequal(checkinput(L([])), 0);
assert_checkequal(checkinput(L(2:4)), 3);
assert_checkequal(checkinput(L), 1);
assert_checkequal(checkinput(L(:)), 4);
