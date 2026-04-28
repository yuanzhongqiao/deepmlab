// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2015 - Scilab Enterprises - Anais AUBERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 13773 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13773
//
// <-- Short Description -->
// save with negative second argument dit not trigger an error


errmsg = [msprintf(gettext("Function not defined for given argument type(s),\n"));
msprintf(gettext("  check arguments or define function %s for overloading.\n"), "%fptr_size")];
assert_checkerror("size(sin)", errmsg);
assert_checkerror("size(sin,1)", errmsg);
