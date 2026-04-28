// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) ????-2008 - INRIA
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 566 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/566
//
// <-- Short Description -->
//    a(2,3,2)='x' returns an empty matrix.

a(2,3,2)='y';
assert_checkfalse(a == []);

