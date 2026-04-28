//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) ????-2008 - INRIA
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 649 -->
// <-- ENGLISH IMPOSED -->
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/649
//
// <-- Short Description -->
//    scilab crashes under windows, under linux, Scilab loops forever,
//    and it uses the whole CPU resource.

// 2009-01-09 mtlb_save is removed => savematfile
// 2015-04-13 savematfile allows double of any dimension

x = rand(5,5,100)+%i;

ierr = execstr("savematfile TMPDIR/bug_649.mat x", "errcatch");

assert_checktrue(ierr==0);
