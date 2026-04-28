// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- INTERACTIVE TEST -->

// <-- Non-regression test for bug 9498 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9498
//
// <-- Short Description -->
// By default history file was not limited

// creates a very big history file
// start scilab, only last 20000 (default) lines are loaded in scilab
// and a message disabled about this
