// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - Calixte DENIZET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- TEST WITH CONSOLE -->
// <-- LINUX ONLY -->
//
// <-- Non-regression test for bug 7568 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7568
//
// <-- Short Description -->

cd TMPDIR;
host('touch MotorDat.m');
host('touch MotorDat.sce');

// exec Mot<TAB> and double-click on an item
