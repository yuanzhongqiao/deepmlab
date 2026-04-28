// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - S/E - Sylvestre Ledru
//
//  This file is distributed under the same license as the Scilab package.
// ===========================================================================
//
// <-- Non-regression test for bug 13000 -->
//
// <-- CLI SHELL MODE -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13000
//
// <-- Short Description -->
// Endless recursive call on []./int8(3) and on int8(3)./[]
//

a = []./int8(3);
assert_checkequal(a, []);
a = int8(3)./[];
assert_checkequal(a, []);

