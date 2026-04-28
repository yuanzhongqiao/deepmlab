// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - Calixte DENIZET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- TEST WITH SCINOTES -->
//
// <-- Non-regression test for bug 9348 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9348
//
// <-- Short Description -->
// Miscolorization of a transposed field

mputl('a.b'' //cdefg', TMPDIR + '/bug_9348.sce')
scinotes(TMPDIR + '/bug_9348.sce');

// the comment should be colorized as a comment and not as a string