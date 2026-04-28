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
// <-- Non-regression test for bug 15647 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15647
//
// <-- Short Description -->
// spzeros(-1,-1) yields a corrupted result

errMsg = _("%s: Wrong value for input argument #%d: Scalar positive integer expected.")
assert_checkerror("spzeros(-1,-1)", msprintf(errMsg, "spzeros", 1));
assert_checkerror("spzeros(1,-1)", msprintf(errMsg, "spzeros", 2));
