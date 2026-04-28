// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->


// <-- Non-regression test for bug 3288 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3288
//
// <-- Short Description -->
// strcat with 3 parameters crashs on windows release mode

rand('seed',3);
n=5;
A=int(10*rand(n,n));
A1=strcat(string(A),' ','c');
if size(A1) <> [5 1] then pause,end