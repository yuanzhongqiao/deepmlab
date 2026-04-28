// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 13603 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13603
//
// <-- Short Description -->
// plot([0 1 2 3]', 10) failed

x = (0:0.1:4)';
plot(x, 10);
curve = gce().children.data;
assert_checkequal(curve, [x 10*ones(x)]);
