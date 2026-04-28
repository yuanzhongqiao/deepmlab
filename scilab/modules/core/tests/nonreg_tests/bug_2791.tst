//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Vincent COUVERT <vincent.couvert@inria.fr>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 2791 -->
//
// <-- ENGLISH IMPOSED -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2791
//
// <-- Short Description -->
// funptr miscomplains about a wrong argument

ierr = execstr("funptr(1);","errcatch");
if ierr <> 999 then pause,end
if lasterror() <> gettext(msprintf("funptr: Wrong type for input argument #1: String expected.\n")) then pause, end
