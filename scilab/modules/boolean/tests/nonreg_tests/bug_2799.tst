// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2006-2008 - INRIA -Serge Steer
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 2799 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2799
//
// <-- Short Description -->
//    Failure to assign boolean values to a sub-matrix when the matrix does 
//    not exist
//    clear A;A(:,1) = [%t;%f];
clear A;A(:,1) = [%t;%f];
if or(A<>[%t;%f]) then pause,end
clear A;A(1,:) = [%f;%t];
if or(A<>[%f,%t]) then pause,end
