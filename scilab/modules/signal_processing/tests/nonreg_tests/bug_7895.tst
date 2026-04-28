//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 7895 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7895
//
// <-- Short Description -->
// fft2() was broken on Windows

assert_checkequal(execstr("m = rand(10, 4);r = fft2(m);", "errcatch"), 0);


