// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 11076 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/11076
//
// <-- Short Description -->
// mlist('r'), tlist('r') returned a wrong error message

msgerr = msprintf(gettext("%s: Can not create a %s with input argument #%d.\n"), "mlist", "mlist", 1);
assert_checkerror ("mlist(''r'')", msgerr );

msgerr = msprintf(gettext("%s: Can not create a %s with input argument #%d.\n"), "tlist", "tlist", 1);
assert_checkerror ("tlist(''r'')", msgerr );
