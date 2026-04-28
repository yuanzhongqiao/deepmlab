// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - Calixte DENIZET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- TEST WITH SCINOTES -->
//
// <-- Non-regression test for bug 9480 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9480
//
// <-- Short Description -->
// Highlighted words after selection were wrong under Windows.

edit bar

// Select "This" on the first line, the other "This" should be correctly highlighted.