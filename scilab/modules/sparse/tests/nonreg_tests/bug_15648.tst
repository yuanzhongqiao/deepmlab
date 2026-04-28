// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET

//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- ENGLISH IMPOSED -->
//
// <-- Non-regression test for bug 15648 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15648
//
// <-- Short Description -->
// sparse([1 1],1,[-1 -1])  crashes scilab

errMsg = _("%s: Wrong values for input argument #%d: Positive integers expected.\n")
assert_checkerror("sparse([1 1],1,[-1 -1])",msprintf(errMsg, "sparse", 3));
