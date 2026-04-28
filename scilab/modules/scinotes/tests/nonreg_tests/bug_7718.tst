// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - Calixte DENIZET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- TEST WITH SCINOTES -->
//
// <-- Non-regression test for bug 7718 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7718
//
// <-- Short Description -->
// There was a bad detection of a function when the list of args was broken.

// In SciNotes:
// function foo(a,..
//              b,..
//              c)
// endfunction

// a,b and c should be colorized (maroon+bold) as function's arguments.
