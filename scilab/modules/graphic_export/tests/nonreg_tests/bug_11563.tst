// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - Scilab Enterprises - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 11563 -->
//
// <-- INTERACTIVE TEST -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/11563
//
// <-- Short Description -->
// Button was called "Open" instead of "Save" in the graphics export file selection GUI.

plot3d
// Menus: File/Export to .../PNG
// Check that the bottom right button is called 'Save'
