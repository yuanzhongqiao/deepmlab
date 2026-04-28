// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 16911 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16864
//
// <-- Short Description -->
// macr2tree(): after a=1:2, b=a(2) is pseudocoded as a funcall instead of as an extraction operation (Scilab 6.0 regression)

function issue_16964()
a = 2;
b = a(1);
c = cos(3);
endfunction

tree = macr2tree(issue_16964);
assert_checkequal(typeof(tree.statements(4).expression), "operation")
assert_checkequal(tree.statements(4).expression.operator, "ext")
assert_checkequal(typeof(tree.statements(6).expression), "funcall")
assert_checkequal(tree.statements(6).expression.name, "cos")
