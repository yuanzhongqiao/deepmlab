// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Simon Lipp
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 4557 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4557
//
// <-- Short Description -->
//    Crash when first argument of regexp is a double

ierr = execstr("regexp([1.,2.,2.],''/foo/'');","errcatch");
if ierr <> 999 then pause,end
