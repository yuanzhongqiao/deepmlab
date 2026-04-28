// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->

// <-- Non-regression test for bug 17417 -->
//
// <-- Bugzilla URL -->
// https://gitlab.com/scilab/scilab/-/issues/17417
//
// <-- Short Description -->
// uigetfile: file_mask doesn't correctly work

// 1 - Create files in a directory (Desktop, ...)
// issue_17417.cfg
// issue_17417.cfg.sav

// 2 - Run uigetfile
uigetfile("*.cfg")

// 3 - Go into directory you created above
// Only "issue_17417.cfg" should be listed

// 4 - Select "*.*" file mask
// "issue_17417.cfg" AND "issue_17417.cfg.sav" should be listed

