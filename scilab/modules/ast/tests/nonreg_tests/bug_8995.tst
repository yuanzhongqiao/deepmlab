// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - ESI Group - Cedric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 8995 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8995
//
// <-- Short Description -->
// Problem with row insertion in empty matrix

foo = [];
foo($+1:$+4) = 1:4;
foo($+1:$+4) = 1:4;

assert_checkequal(foo, [1:4 1:4]);
