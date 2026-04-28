// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - Cedric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16396 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16396
//
// <-- Short Description -->
// array extraction with : crash the software

computed = 1:10;
assert_checkequal(((1:10))(1), computed(1));
assert_checkequal(((1:10))(1:10), computed);
assert_checkequal(((1:10)')(1:10), computed');
assert_checkequal(((1:10))(:), computed');
assert_checkequal((1:10)(:), computed');