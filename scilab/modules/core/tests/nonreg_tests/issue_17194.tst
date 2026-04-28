// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17194 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17194
//
// <-- Short Description -->
// macr2tree() yields 3 operands on "cc" operator
//

// Test with CC operator
function testCC()
    A=[1;2;3];
endfunction

ccTree = macr2tree(testCC);

assert_checkequal(size(ccTree(5)(2).expression.operands), 2);
assert_checkequal(typeof(ccTree(5)(2).expression.operands(1)), "operation");
assert_checkequal(ccTree(5)(2).expression.operands(1).operator, "cc");
assert_checkequal(typeof(ccTree(5)(2).expression.operands(2)), "cste");

// Test with RC operator (to check coherence)
function testRC()
    A=[1,2,3];
endfunction

rcTree = macr2tree(testRC);

assert_checkequal(size(rcTree(5)(2).expression.operands), 2);
assert_checkequal(typeof(rcTree(5)(2).expression.operands(1)), "operation");
assert_checkequal(rcTree(5)(2).expression.operands(1).operator, "rc");
assert_checkequal(typeof(rcTree(5)(2).expression.operands(2)), "cste");
