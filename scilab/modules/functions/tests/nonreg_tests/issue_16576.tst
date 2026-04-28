// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 16576 -->
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16576
//
// <-- Short Description -->
// macr2tree() (and maybe tree2code) kills recursive extractions made with indices (it's OK with fields)


function b = issue_16576_1()
    plot
    b = gcf().children.axes_reverse(:,2)
endfunction

expected = [
    "function [b] = issue_16576_1()"        ; ...
    "plot"                                  ; ...
    "b = gcf().children.axes_reverse(:,2)"  ; ...
    "endfunction"                           ; ...
    ""                                      ; ...
];

assert_checkequal(tree2code(macr2tree(issue_16576_1)), expected);



function issue_16576_2()
    a.cd.efg.h = rand(4,10)
    a.cd.efg.h(5) = 0
    a.cd.efg.h(2,5) = -1
    b = a.cd.efg
    b = a.cd.efg.h(7)
    b = a.cd.efg.h(2,3)
endfunction

expected = [
"function issue_16576_2()"; ...
"a.cd.efg.h = rand(4,10)" ; ...
"a.cd.efg.h(5) = 0"       ; ...
"a.cd.efg.h(2,5) = -1"    ; ...
"b = a.cd.efg"            ; ...
"b = a.cd.efg.h(7)"       ; ...
"b = a.cd.efg.h(2,3)"     ; ...
"endfunction"             ; ...
""                        ; ...
];

assert_checkequal(tree2code(macr2tree(issue_16576_2)), expected);
