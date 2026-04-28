// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17354 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17354
//
// <-- Short Description -->
// barh produces wrong display

x = [1 2 5];
y = [1 4 7;2 5 8;3 6 9];
h = barh(x,y,'stacked');
assert_checkequal(h(1).y_shift, [0 0 0]);
assert_checkequal(h(3).y_shift, [5 7 9]);
