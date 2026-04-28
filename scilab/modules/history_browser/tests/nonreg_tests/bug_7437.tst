// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->

// <-- Non-regression test for bug 7437 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7437
//
// <-- Short Description -->
// if history file was invalid, history browser crashed.
//

// start scilab once time
// edit SCIHOME/history
editor SCIHOME/history
// remove first "// -- Begin Session"
// and restart scilab


