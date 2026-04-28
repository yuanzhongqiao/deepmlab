// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 14498 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14498
//
// <-- Short Description -->
// size([],3) returned 1 instead of 0

assert_checkequal(size([],3), 0)
