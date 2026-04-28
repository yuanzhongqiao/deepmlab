// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 4228 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4228
//
warning("off")
ierr = 999;
ierr = execstr("mclearerr(10000);","errcatch");
if ierr <> 0 then pause,end
warning("on")