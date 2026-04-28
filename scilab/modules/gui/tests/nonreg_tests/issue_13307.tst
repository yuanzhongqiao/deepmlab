// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 13307 -->
//
// <-- TEST WITH GRAPHIC -->
// <-- INTERACTIVE TEST -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13307
//
// <-- Short Description -->
// Clicking on the same item from a listbox a second time did not trigger the callback

function issue_13307()
    disp(gcbo.value)
endfunction

h = uicontrol("style", "listbox", ...
    "string", sprintf("item %d\n", (1:10)'), ...
    "max", 3, ...
    "callback", "issue_13307", ...
    "position", [50 50 100 100]);

// click on the first item ("item 1") then click still on the same item
// We must see in the Console
//  1.
//
// 1.

// Use with up/down arrow keys, press space to select / unselect multiple items

// With demo_gui
// demo_gui()
// select Graphics > 2D and 3D plots > plot2d
// close plot2d window
// click still on plot2d
