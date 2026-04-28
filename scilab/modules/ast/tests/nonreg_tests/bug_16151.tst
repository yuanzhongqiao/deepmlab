// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16151 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16151
//
// <-- Short Description -->
// isequal(1:$, 2:$) returns %T

assert_checktrue(isequal(1:$,1:1:$));
assert_checktrue(isequal($-1:$,$-1:1:$));
assert_checkfalse(isequal($-1:$,$-1:2:$));
assert_checkfalse(isequal($:-1:1,1:$));
assert_checkfalse(isequal(1:$,2:$));
assert_checkfalse(isequal(1:$,1:2:$));
assert_checkfalse(isequal(1:$,1:$-1));
assert_checkfalse(isequal(1:$,1:2:$));


