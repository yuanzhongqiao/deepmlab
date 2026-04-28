// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for bug 10344 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/10344
//
// <-- Short Description -->
// Windows SDK 7.1 was not detected with VS Express 2010 on x64 platform.
// =============================================================================

// Install Scilab x64
// Install Visual studio 2010 C++ Express
// Install Windows SDK 7.1 with x64 component


test_run('dynamic_link')

