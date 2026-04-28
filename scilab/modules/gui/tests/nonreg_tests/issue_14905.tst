// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 14905 -->
//
// <-- TEST WITH GRAPHIC -->
// <-- INTERACTIVE TEST -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14905
//
// <-- Short Description -->
// x_choose_modeless does not work: the window is empty and Scilab is blocked.

// Test with x_choose_modeless
// Copy/paste this code in the console:
n = x_choose_modeless(['item1';'item2';'item3'],['that is a comment';'for the dialog'])
// Hit ENTER
// Check that there is no new prompt after this command (Scilab is waiting for the window to be closed)
// Check that you can enter some text in Scinotes or open Preferences (Scilab GUI is reactive)
// Choose an item in the list + Click on "Ok" button
// Check that its index is displayed in the console and that the x_choose window has been closed

// Try the same thing replacing x_choose_modeless by x_choose
// Everything should behave in the same way except that Scilab GUI is not reactive while the x_choose window is opened
