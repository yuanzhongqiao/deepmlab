// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan SIMON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- TEST WITH SCINOTES -->
//
// <-- Non-regression test for bug 5459 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/5459
//
// <-- Short Description -->
//   editor "block" scilab with example

cd SCI/modules/overloading/macros
a=ls('*.sci')
size(a)
editor(a)
// all the files should open normally




