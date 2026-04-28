// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 16557 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16557
//
// <-- Short Description -->
// macr2tree (and tree2code ?) fails for braces {2} as cells constructor
//

function test()
    e = {2}
endfunction
t = macr2tree(test);
assert_checkequal(t.statements(2).expression.operator, "crc");
assert_checkequal(t.statements(2).expression.operands(1).value, 2);
assert_checkequal(t.statements(2).lhs(1).name, "e");

function test()
    e = {2, "ab"}
endfunction
t = macr2tree(test);
assert_checkequal(t.statements(2).expression.operator, "crc");
assert_checkequal(t.statements(2).expression.operands(1).value, 2);
assert_checkequal(t.statements(2).expression.operands(2).value, "ab");
assert_checkequal(t.statements(2).lhs(1).name, "e");

