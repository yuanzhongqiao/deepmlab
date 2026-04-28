// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008-2008 - INRIA - Jean-Baptiste Silvy
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->

// <-- Non-regression test for bug 2906 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2906
//
// <-- Short Description -->
// mesh : colors of hidden meshs (to compare with scilab 4.1.2)
// also clipping too strict make outside line disappear.

[X,Y]=meshgrid(-1:.1:1,-1:.1:1);
Z=X.^2-Y.^2;
xtitle('z=x2-y ^2');
mesh(X,Y,Z);

// check that the hidden color is white and clipping does not remove outside
// line




