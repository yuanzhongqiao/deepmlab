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
// <-- Non-regression test for issue 17355 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17355
//
// <-- Short Description -->
// bar() function wrongly returns a Compound (while barh() returns a vector of Polylines).

x = [1 2 5];
y = [1 -5 6;3 -2 7;4 -3 8];
h = bar(x,y);
assert_checktrue(h.type <> "Compound");
assert_checkequal(size(h), [3 1]);
assert_checktrue(h.type == "Polyline");
