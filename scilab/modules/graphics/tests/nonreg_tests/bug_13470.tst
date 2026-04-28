// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Scilab Enterprises - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 13470 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13740
//
// <-- Short Description -->
//    histplot(0,0,%t) crashed.
// =============================================================================

errmsg=msprintf(_("%s: Wrong value for input argument #%d: Must be in the interval %s.\n"),"histc",2,"[1, oo)");
assert_checkerror("histplot(0,0,%t)", errmsg);
