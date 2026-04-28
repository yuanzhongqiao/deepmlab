// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - SE - Sylvestre Ledru
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 12033 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12033
//
// <-- Short Description -->
// assert_checkalmostequal was failing with two %inf values.


ret=assert_checkalmostequal ( %inf , %inf, 1.e-10)
assert_checkequal(ret, %t);
