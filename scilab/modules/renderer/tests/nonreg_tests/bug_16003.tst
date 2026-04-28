// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - UTC - Stéphane MOTTELET
//
//// This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for bug 16003 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16003
//
// <-- Short Description -->
// Zoom with mouse scroll wheel is broken on simple surfaces

// after running the following two lines verify that you can
// zoom with the mouse wheel on the triangle and on the square
plot3d([0 1 1 0]',[1 1 0 0]',[1 1 0 0]');
plot3d(2+[0 1 1]',[1 0 0]',[1 0 1]');
