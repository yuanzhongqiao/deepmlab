// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 9328 -->
//
// <-- CLI SHELL MODE -->
// 
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9328
//
// <-- Short Description -->
// Scilab randomly crached at startup under Mac OS X when calling
// functions returning no value (lines, modes, banner, ...).

for k=1:1000
    lines(0);
    mode(-1);
end

mprintf("Bug #9328 is fixed.\n");