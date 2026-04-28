// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - Scilab Enterprises - Calixte DENIZET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->

// <-- Non-regression test for bug 12234 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12234
//
// <-- Short Description -->
// Crash with invalid property

refMsg = msprintf(_("''%s'' property does not exist for this handle.\n"), "data");
e=gce();
assert_checkerror("set(e, ''interp_color_vector'', 1:4)", refMsg);
