// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008-2008 - INRIA - Jean-Baptiste Silvy
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->

// <-- Non-regression test for bug 711 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/711
//
// <-- Short Description -->
// Problem with window position handling

// specify init position
initPos = [100,100];
pos = initPos;
f = gcf();

// window should not move
for k = 1:10,
  f.figure_position = pos;
  pos = f.figure_position;
end
assert_checkequal(pos,initPos);
