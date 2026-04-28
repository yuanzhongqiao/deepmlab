// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for issue 11852 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/11852
//
// <-- Short Description -->
// File browser doesn't update when creating a file from SciNotes

// 1 - Go to TMPDIR 
cd TMPDIR
// Check that FileBorwser shows the content of TMPDIR

// 2 - File opening
scinotes("SCI/modules/ui_data/tests/nonreg_tests/issue_11852.tst")

// 3 - Save file in TMPDIR
// In SciNotes, save file in TMPDIR using File/Save As menu
// Check that "issue_11852.tst" is listed in FileBrowser
