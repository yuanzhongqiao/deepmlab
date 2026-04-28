//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 20010 - INRIA - Serge Steer
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 6698 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/6698
//
// <-- Short Description -->
// isreal does not work on hypermatrix
A = ones(2,2,2);
if or(~isreal(A)) then pause,end
if or(~isreal(A,0)) then pause,end
