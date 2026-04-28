//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 2153 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2153
//
// <-- Short Description -->
//    addition and subtraction of matrix and hypermatrix of same dimension and size do not work

if execstr("zeros(1,3) + matrix([0 0 0], [1 3])", "errcatch")<>0 then pause,end
