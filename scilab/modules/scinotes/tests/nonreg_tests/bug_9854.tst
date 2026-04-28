// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Calixte DENIZET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- TEST WITH SCINOTES -->
//
// <-- Non-regression test for bug 9854 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9854
//
// <-- Short Description -->
// Miscolorization when a string contains several dots

mputl('a=""..""', TMPDIR + '/bug_9854.sce')
scinotes(TMPDIR + '/bug_9854.sce');

// All the string must have the same color.
