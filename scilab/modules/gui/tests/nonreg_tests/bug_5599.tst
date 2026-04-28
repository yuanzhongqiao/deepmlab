// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 5599 -->
// <-- INTERACTIVE TEST -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/5599
//
// <-- Short Description -->
// When I plot a graph and intend to save the figure, clicking 'File'->'Save', renders the normal window where you write the filename and so on.
// However, the button where it is supposed to say "Save", it says "Open".
// Clicking "Open" gives message "Figure saved" in the Scilab console, and the file is saved.

plot2d
// File -> Save
// Check that there the "validation" button is called "Save" 