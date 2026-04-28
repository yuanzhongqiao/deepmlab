// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for bug 14916 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14916
//
// <-- Short Description -->
// read(%io(1), 1, 1, '(a)') + keyboard input + enter crashed Scilab

read(%io(1), 1, 1, '(a)')

// Enter some input in the console, and validate by pressing <enter>
// TEST: 
//  - Scilab should not have crashed
//  - Your input should be displayed in ans

