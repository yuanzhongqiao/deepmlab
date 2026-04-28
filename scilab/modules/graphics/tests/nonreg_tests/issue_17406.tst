// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for issue 17406 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17406
//
// <-- Short Description -->
// XCOS block "LOOKUP_f": DATA -> LOAD not working
// Actually an issue in `edit_curv`

// Launch `edit_curv()`
edit_curv([1 3 2])

// Test 1: Check that issue is fixed 
// Click on "Data" menu and then "Load"
// A file selection dialog must appear

// Test 2: issue found while fixing #17406: when canceling "Bounds" setting, `edit_curv` is broken
// Click on "Data" menu and then "Bounds"
// Click on "Cancel"
// Click again on "Data" menu and then "Bounds"
// A dialog box must appear

// Test 2: issue found while fixing #17406: when data is cleared then "Reframe" fails and breaks `edit_curv` internal loop
// Click on "Data" menu and then "Clear"
// Click on "Data" menu and then "Reframe"
// An error message will appear in Scilab console
// Click on "Data" menu and then "Bounds"
// A dialog box must appear (showing the `edit_curv` internal loop still runs)



