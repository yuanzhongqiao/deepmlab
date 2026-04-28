// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - Calixte DENIZET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->

// <-- Non-regression test for bug 6986 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/6986
//
// <-- Short Description -->
// edit('toto.sce') created a file toto.sce.sci containing a function named
// toto.sce and now edit should open in the editor the file toto.sce.

edit(TMPDIR + '/toto.sce');