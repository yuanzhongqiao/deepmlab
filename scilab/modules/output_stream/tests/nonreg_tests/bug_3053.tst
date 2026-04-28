// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009-2009 - Francois Vogel
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 3053 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3053
//
// <-- Short Description -->
//  mprintf("%s\n","hell");
//  100% CPU endless stuck.
//
//  It may display:
//  ell
//  the first time, but the second time it's stuck.

// <-- INTERACTIVE TEST -->
//
//
// paste the lines below in Scilab: it must not hang

// used to hang Scilab
mprintf("%s\n","hell");
mprintf("%s\n","hell");
mprintf("%s\n","hell");
mprintf("%s\n","hell");
mprintf("%s\n","hell");

