// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- NO CHECK REF -->
// <-- INTERACTIVE TEST -->
// <-- TEST WITH GRAPHIC -->

// <-- Non-regression test for bug 14797 -->
//
// <-- Bugzilla URL -->
// https://gitlab.com/scilab/scilab/-/issues/14797
//
// <-- Short Description -->
// Tooltip does not work for edit uicontrol 

// run code
f=figure();
f.figure_size=[200 200];
uicontrol("parent", f, "style", "edit", "string", "", "tooltipstring", "hello");

// now put the mouse over the edit area to check that the tooltip "hello" is displayed
