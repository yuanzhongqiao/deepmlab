// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - Calixte DENIZET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- TEST WITH SCINOTES -->
//
// <-- Non-regression test for bug 9505 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9505
//
// <-- Short Description -->
// A LaTeX string in a comment was not considered as a comment

mputl('//abc$xyz$', TMPDIR + '/bug_9505.sce')
scinotes(TMPDIR + '/bug_9505.sce');

// Put the caret just after the second $ and <CTRL>+E
// Nothing happen: normal, it is the expected behaviour.