// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 10560 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/10560
//
// <-- Short Description -->
// genetic algorithms demos failed

ierr = exec("SCI/modules/optimization/demos/genetic/GAdemo.sce", "errcatch", -1);
assert_checkequal(ierr, 0);
