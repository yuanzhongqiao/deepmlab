//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 3827 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3827
//
// <-- Short Description -->
//   Atlas library crashs scilab with this example

a=[1 2 3;2 3 4;3 4 5];
ev=spec(a);
if or(size(ev)<> [3 1]) then pause,end
