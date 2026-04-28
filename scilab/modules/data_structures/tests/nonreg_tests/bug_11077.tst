// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 11077 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/11077
//
// <-- Short Description -->
// rlist() returned an error

msg = msprintf(gettext("%s: Wrong number of input argument(s): %d or %d expected.\n"),"rlist",2,3);
assert_checkerror("rlist()", msg);
