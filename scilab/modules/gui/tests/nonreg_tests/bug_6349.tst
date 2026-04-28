// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 6349 -->
// <-- INTERACTIVE TEST -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/6349
//
// <-- Short Description -->
// The callback of an 'edit' uicontrol was only executed when it lost focus.

// Launch the demo: GUI/Uicontrols 2

// Entrer a new title in the bottom left 'edit' uicontrol and press ENTER

// Check the title has been updated.