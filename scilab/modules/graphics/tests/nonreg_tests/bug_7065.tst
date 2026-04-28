// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Pierre Lando
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 7065 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7065
//
// <-- Short Description -->
// "getColorIndex" used some global variable prohibiting user's calls.


if execstr("getColorIndex(""blue"")", "errcatch")<>0 then pause, end;
