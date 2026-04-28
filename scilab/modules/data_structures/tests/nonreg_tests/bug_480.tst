//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) ????-2008 - INRIA
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- Non-regression test for bug 480 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/480
//
// <-- Short Description -->
//    Bug Report Id: 12070200362710754
//    [u]intN() and iconvert() do not handle hypermatrices.

a=matrix(1:9, [1,3,3]);
assert_checktrue(execstr("int8(a)", "errcatch")==0);
