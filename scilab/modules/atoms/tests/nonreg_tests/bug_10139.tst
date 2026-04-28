// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH ATOMS -->
// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for bug 10139 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/10139
//
// <-- Short Description -->
// The atomsTest function did not manage a specific test name.

// Install a module

atomsInstall('apifun')
atomsTest('apifun')
atomsTest('apifun', 'checkreal')
atomsTest('apifun', ['checkreal', 'complete'])
