// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008-2008 - INRIA - Jean-Baptiste Silvy
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->

// <-- Non-regression test for bug 2815 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2815
//
// <-- Short Description -->
// sub_ticks disappear when changed

plot2d()
f=gcf();

// subticks should not disappear
f.children.sub_ticks;
f.children.sub_ticks=[1,1];
f.children.sub_ticks=[2,1];
