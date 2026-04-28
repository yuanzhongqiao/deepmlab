// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan SIMON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- TEST WITH SCINOTES -->
//
// <-- Non-regression test for bug 5465 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/5465
//
// <-- Short Description -->
//   "unmodified reference" was not change after saving a file

editor SCI/modules/atoms/macros/atomsAutoload.sci
// <SPACE> (for example)
// CTRL+S
// CTRL+Z
// the file should appear as modified

