// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- INTERACTIVE TEST -->
// <-- Non-regression test for bug 3666 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3666
//
// <-- Short Description -->
//    char encoding with length()

S = 'ôpéra';
assert_checkequal(length(S), 5);
