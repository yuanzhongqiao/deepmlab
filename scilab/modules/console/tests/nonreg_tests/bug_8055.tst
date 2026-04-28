// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - Calixte DENIZET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- TEST WITH CONSOLE -->
//
// <-- Non-regression test for bug 8055 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8055
//
// <-- Short Description -->
// lines() was updated when the console got the focus.

lines(123);
lines()

// Now give the focus to another window and give it to the console

lines()

// The result may be the same as the previous one.
