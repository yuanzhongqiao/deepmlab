// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - Calixte DENIZET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- TEST WITH SCINOTES -->
//
// <-- Non-regression test for bug 7722 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7722
//
// <-- Short Description -->
// Several FindReplace windows could be opened.

// In SciNotes, open two files, select the first and open a find/replace window (ctrl+F)
// and repeat the process in the second file. The first find/replace window should close
// and another one should be opened.
