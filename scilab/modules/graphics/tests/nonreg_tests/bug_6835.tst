// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Manuel Juliachs
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- INTERACTIVE TEST -->

// <-- Non-regression test for bug 6835 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/6835
//
// <-- Short Description -->
// Performing interactive rotations after having executed a plot3d command
// causes Scilab (64-bit version) to freeze on Windows 64-bit
//

plot3d();

// Perform several successive interactive rotations, moving the
// mouse as randomly as possible. Check whether freezes occur
// or not.

