//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 3280 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3280
//
// <-- Short Description -->
//A permanent variable   'L' is defined when launching scilab with the '-l' option.

if isdef('L') then pause,end