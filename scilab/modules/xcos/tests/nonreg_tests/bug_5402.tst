/ =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- XCOS TEST -->
//
// <-- Non-regression test for bug 5402 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/5402
//
// <-- Short Description -->
// When "Save as" is canceled, status bar still displays "Saving diagram ...".

// start xcos

// File >> Save as >> Cancel

// Check that the status bar content is empty
