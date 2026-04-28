// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->

//
// <-- Non-regression test for bug 3849 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3849
//
// <-- Short Description -->
// From a graphic window, the latest directory in which a figure has been exported is not memorized. The default directory proposed for any forthcoming exportation is always "Desktop\My documents", not the latest one. 

// plot3d
// File -> Export to
// Select a directory to export (change default one)
// Export the file
// Then  File -> Export to
// Check that current directory for file selection is the one selected before