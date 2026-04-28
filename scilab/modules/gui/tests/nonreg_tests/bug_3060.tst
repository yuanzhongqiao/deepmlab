// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for bug 3060 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3060
//
// <-- Short Description -->
// When I play (ie moving everything quickly like a dumb guy) with the rotation (full screen), it crashes Scilab.

plot3d();
f = gcf();
f.figure_size = [1000,1000];
if f.figure_size <> [1000,1000] then pause,end
// then rotate the figure very fast and sometime move the cursor outside the window

