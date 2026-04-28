// ============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Scilab Enterprises - Pierre-Aime AGNEL
//
//  This file is distributed under the same license as the Scilab package.
// ============================================================================

// <-- CLI SHELL MODE -->
// <-- Non-regression test for bug 14662 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14662
//
// <-- Short Description -->
// A = [A 'some text'] matrix of string concatenation with simple quote led to a parser error

A = "some text";
ierr = execstr("A = [A ''some text''];", "errcatch");
assert_checkequal(ierr, 0);

