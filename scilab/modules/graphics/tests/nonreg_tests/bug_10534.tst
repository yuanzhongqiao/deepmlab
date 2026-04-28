// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->

// <-- Non-regression test for bug 10534 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/10534
//
// <-- Short Description -->
// DegenerateMatrixException: Scale matrix with 0 factor.

// This test just check that there is no exception, rendering is not checked.

x = [0 0;
     0 1;
     1 1];

y = [1 1;
     2 2;
     2 1];

z = [1 1;
     1 1;
     1 1];

plot3d(x, y, z);