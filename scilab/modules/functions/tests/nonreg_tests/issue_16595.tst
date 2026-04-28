// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 16595 -->
//
// <-- NO CHECK REF -->
// <-- CLI SHELL MODE -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16595
//
// <-- Short Description -->
// string(macro) and tree2code() yield wrong code for multiline arrays including some comments, breaking its compilation.

function issue_16595()
    a = [1 2 3
        // Remark
        7 8 9
        ];
endfunction

// tree2code case
expected = [
    "function issue_16595()"        ; ...
    "a = [1,2,3;"                   ; ...
    "     // Remark;"               ; ...
    "     7,8,9];"                  ; ...
    "endfunction"                   ; ...
    ""
];

assert_checkequal(tree2code(macr2tree(issue_16595)), expected);

// string case
[_, _, txt] = string(issue_16595);

expected = [
    " "                    ; ...
    "a = [1, 2, 3;"        ; ...
    "    // Remark"        ; ...
    "    7, 8, 9];"        ; ...
    " "
];

assert_checkequal(txt, expected);