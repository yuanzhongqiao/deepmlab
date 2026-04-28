// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for issue 16894 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16894
//
// <-- Short Description -->
// filebrowser is not refreshed after a deletefile instruction

// 1 - Go to TMPDIR 
cd TMPDIR
// Check that FileBorwser shows the content of TMPDIR

// 2 - File creation
mputl("issue_16894", "issue_16894.txt")
// Check that "issue_16894.txt" is listed in FileBrowser

// 3 - File removal
mdelete("issue_16894.txt")
// Check that "issue_16894.txt" is no more listed in FileBrowser

// 4 - All at once (actually the bug reported)
mputl("issue_16894", "issue_16894.txt")
deletefile("issue_16894.txt")
// Check that "issue_16894.txt" is not listed in FileBrowser