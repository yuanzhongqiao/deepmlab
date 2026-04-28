// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 16670 -->
//
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16670
//
// <-- Short Description -->
// c(1)(3).line_style = 8; where c is a list of vectors of polyline handles crashes Scilab

plot2d();
c = gca().children.children;
c = list(c(1:2), c([3 1]));
c(2)(1).line_style = 8;
assert_checkequal(c(2)(1).line_style, 8);

/*** Issue reproducted using MList and struct ***/
// MList extraction
function res=%MyType_e(arg, ml)
    res = ml.f1;
end
// MList extraction call in case of insertion
function res=%MyType_6(arg, ml)
    res = ml.f1;
end
// insert struct in MList
function res=%st_i_MyType(arg, st, ml)
    ml.f1 = st
    res = ml
end

ml = mlist(["MyType", "f1"], struct("test", 42));
l = list(list(), ml);
l(2)(1).test = 12;
assert_checkequal(l(2)(1).test, 12);
