// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
//
// <-- Non-regression test for bug 8965 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8965
//
// <-- Short Description -->
// 'copy' function for handles is broken.

a=gca();
assert_checkequal(execstr("a1=copy(a)", "errcatch"), 0);