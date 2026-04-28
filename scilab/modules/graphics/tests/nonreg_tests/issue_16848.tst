// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

// <-- Non-regression test for issue 16848 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16848
//
// <-- Short Description -->
// scatter3d(): negative mcolors were ignored to map the colormap 

scatter3d(rand(3,100),rand(3,100),rand(3,100),1,-rand(3,100));
assert_checkequal(size(gce().mark_foreground), [1 300]);
