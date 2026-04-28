// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - Scilab Enterprises - Calixte DENIZET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for bug 11244 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/11244
//
// <-- Short Description -->
// There was an error with browsevar when deleting a global var

browsevar();
clear a
global a
clearglobal a
b=2

// No error in console.