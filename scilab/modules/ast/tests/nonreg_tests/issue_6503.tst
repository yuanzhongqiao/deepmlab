// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 6503 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/6503
//
// <-- Short Description -->
// select/case: It would be nice that Scilab supports grouped cases

function r = select_cell(a)
    select a
    case {1 2}      // Matches 1 or 2
        r = 1
    case {3 4}      // Matches 3 or 4
        r = 2
    case {{1, 2}}   // Matches the cell {1, 2}
        r = 3;
    else            //default
        r = 0
    end
endfunction

assert_checkequal(select_cell(0), 0);
assert_checkequal(select_cell(1), 1);
assert_checkequal(select_cell(2), 1);
assert_checkequal(select_cell(3), 2);
assert_checkequal(select_cell(4), 2);
assert_checkequal(select_cell({1 2}), 3);
assert_checkequal(select_cell({3 4}), 0);
