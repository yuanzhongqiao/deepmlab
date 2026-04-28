// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- INTERACTIVE TEST -->

// <-- Non-regression test for bug 17145 -->
//
// <-- Bugzilla URL -->
// https://gitlab.com/scilab/scilab/-/issues/17145
//
// <-- Short Description -->
// ctrl + a does not update value and does not trigger callback on listbox

uicontrol(...
    "style", "listbox", ...
    "backgroundcolor", [1 1 1], ...
    "max", 2, "min", 0, ...
    "unit", "normalized", ...
    "position", [0 0 1 1], ...
    "string", ["item 1" "item 2" "item 3" "item 4" "item 5" "item 6"], ...
    "callback", "disp(gcbo.value)")

//press ctrl + a with focus in listbox, callback must display
// 1.   2.   3.   4.   5.   6.