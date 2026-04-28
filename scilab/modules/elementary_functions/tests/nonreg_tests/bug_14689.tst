// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 14689 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14689
//
// <-- Short Description -->
//    resize_matrix(mat,[0 3]) does not return []

assert_checkequal(resize_matrix(rand(2,4), [1 0]), []);
assert_checkequal(resize_matrix(rand(2,4), [0 3]), []);
assert_checkequal(resize_matrix(rand(2,4), [0 0]), []);
assert_checkequal(resize_matrix(rand(4,3,2), [0 2 3]), []);
assert_checkequal(resize_matrix(rand(4,3,2), [5 0 1]), []);
assert_checkequal(resize_matrix(rand(4,3,2), [4 4 0]), []);
