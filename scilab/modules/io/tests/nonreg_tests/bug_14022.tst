// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2015 - Scilab Enterprises - Charlotte HECQUET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 14022 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14022
//
// <-- Short Description -->
// getscilabkeywords() is k.o

assert_checkequal(execstr("kw=getscilabkeywords()", "errcatch"), 0);
