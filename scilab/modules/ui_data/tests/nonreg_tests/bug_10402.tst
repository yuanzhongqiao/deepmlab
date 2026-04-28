// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - Scilab Enterprises - Calixte DENIZET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for bug 10402 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/10402
//
// <-- Short Description -->
// Exception was thrown when a filter was set on an expanded tree in filebrowser.

cd SCI
filebrowser();

// expand a dir
// set the filter to m* and <ENTER>