// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Yann COLLETTE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 7077 -->
// <-- INTERACTIVE TEST -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7077
//
// <-- Short Description -->
// uigetfont makes scilab hangs when you clicked directly on cancel

// To save some paper, this test is interactive

fontname = uigetfont();

// Now click on the cancel button.
// Scilab should not hangs.

