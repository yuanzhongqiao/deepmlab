//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 133 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/133
//
// <-- Short Description -->
//    The man page for mtlb_fftshift...

M = [1 2;3 4];

// Check the result is the same as Matlab one
if or(mtlb_fftshift(M)<>[4 3;2 1]) then pause,end
