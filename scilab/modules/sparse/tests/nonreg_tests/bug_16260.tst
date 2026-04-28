// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16260 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16260
//
// <-- Short Description -->
// nnz(): please reopen it to overloading (Regression), and extend it to dense boolean and polynomial arrays

assert_checkequal(nnz([%t %f]),1)
assert_checkequal(nnz([%t %t;%f %f]),2)
assert_checkequal(nnz([%s 0]),1)
assert_checkequal(nnz([%s %s;0 0]),2)

