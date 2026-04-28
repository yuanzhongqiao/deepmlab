// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17197 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17197
//
// <-- Short Description -->
// macr2tree fails to manage extractions
//

function test(), b=1, b(1); endfunction
assert_checkequal(typeof(macr2tree(test)(5)(3)(2)), "operation");
assert_checkequal(tree2code(macr2tree(test))(2), "b = 1, b(1);");

function test2(), b=1, b(1,2); endfunction
assert_checkequal(typeof(macr2tree(test2)(5)(3)(2)), "operation");
assert_checkequal(tree2code(macr2tree(test2))(2), "b = 1, b(1,2);");
    
function test3(), b=1, b(1)(2); endfunction
assert_checkequal(typeof(macr2tree(test3)(5)(3)(2)), "operation");
assert_checkequal(tree2code(macr2tree(test3))(2), "b = 1, b(1)(2);");
    