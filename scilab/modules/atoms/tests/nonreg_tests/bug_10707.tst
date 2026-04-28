// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH ATOMS -->
// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for bug 10707 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/10707
//
// <-- Short Description -->
// atomsInstall failed to use the path shortcut

// download a module and copy it in your home


atomsInstall('~/grocer_1.52-1.bin.zip')
