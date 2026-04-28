// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 9785 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9785
//
// <-- Short Description -->
// fscanfMat failed on this file
// fixed in 5.3.2


r = fscanfMat('SCI/modules/fileio/tests/nonreg_tests/bug_9785.csv');
ref = zeros(8, 1430);
assert_checkequal(r,ref);
