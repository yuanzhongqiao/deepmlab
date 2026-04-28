// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - Calixte DENIZET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- TEST WITH SCINOTES -->
//
// <-- Non-regression test for bug 8697 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8697
//
// <-- Short Description -->
// An exception was thrown when an empty document was reload.

scinotes();

// Choose menu File > Reload and no exception should occurred.