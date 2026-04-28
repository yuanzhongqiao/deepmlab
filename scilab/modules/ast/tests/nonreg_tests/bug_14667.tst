// ============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Scilab Enterprises - Pierre-Aime AGNEL
//
//  This file is distributed under the same license as the Scilab package.
// ============================================================================

// <-- CLI SHELL MODE -->
// <-- Non-regression test for bug 14667 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14667
//
// <-- Short Description -->
// Multi line string in a matrix without line feed generated a non terminal parser state

ierr = execstr(["A = [""some text ..."; ...
"ending here""]"], "errcatch");
assert_checktrue(ierr <> 0); // previous line must generate an error

ierr = execstr("A = ""some text ...", "errcatch");
assert_checktrue(ierr <> 0); // previous line must generate an error
