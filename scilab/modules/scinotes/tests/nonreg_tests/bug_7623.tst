// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - Calixte DENIZET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- TEST WITH SCINOTES -->
//
// <-- Non-regression test for bug 7623 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7623
//
// <-- Short Description -->
// An extra char was added to the selection with action "Evaluate Selection"

// Open SciNotes in the console and type (take care to the comma):
// "Hello World",
// Select "Hello World" (but not the comma)
// and click on menu "Evaluate Selection"

// In the console, you should just see "Hello World" not followed by the comma
