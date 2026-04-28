// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008-2008 - INRIA - Jean-Baptiste Silvy
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->

// <-- Non-regression test for bug 2143 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2143
//
// <-- Short Description -->
// Allocating of default figure colormap produces a warning.

// should not produve any warning
f=gdf();
f.color_map($+1,:)=[0.8 0.8 0.8];  



