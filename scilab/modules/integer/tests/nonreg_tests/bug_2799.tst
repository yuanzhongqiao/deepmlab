//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2006-2008 - INRIA -Serge Steer
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 2799 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2799
//
// <-- Short Description -->
//    Failure to assign boolean values to a sub-matrix when the matrix does 
//    not exist
//    clear A;A(:,1) = [int32(3);int32(4)];
clear A;A(:,1) = [int32(3);int32(4)];
if or(A<>[int32(3);int32(4)]) then pause,end
clear A;A(1,:) = [int32(4);int32(3)];
if or(A<>[int32(4),int32(3)]) then pause,end
