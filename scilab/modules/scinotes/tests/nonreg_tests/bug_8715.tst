// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - Calixte DENIZET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- TEST WITH SCINOTES -->
//
// <-- Non-regression test for bug 8715 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8715
// https://gitlab.com/scilab/scilab/-/issues/8716
//
// <-- Short Description -->
// Problem of order when dnd'ing the tabs

scinotes();

// Open two files
// ctrl+G to open the Code Navigator
// Switch them in dnd'ing one of them
// Look at the Code Nav., the order must have been updated.
// Look at the order of the tabs and close SciNotes
// Reopen SciNotes
// The order should the same as previous