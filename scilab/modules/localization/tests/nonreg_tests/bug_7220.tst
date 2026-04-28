// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 7220 -->
// <-- INTERACTIVE TEST -->
// <-- WINDOWS ONLY -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7220
//
// <-- Short Description -->
//  On Windows, when you start Scilab with "WScilex -l ru_RU", some menus were disabled.

// launch scilab by this line:
host(SCI+"/bin/Wscilex -l ru_RU")

// check that menus are not grayed
