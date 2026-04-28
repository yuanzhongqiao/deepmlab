// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15653 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15653
//
// <-- Short Description -->
// sparse - complex substraction is corrupted

assert_checkequal(sparse(1)-%i,1-%i);
assert_checkequal(%i-sparse(1),%i-1);
