// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - Calixte DENIZET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- TEST WITH CONSOLE -->
//
// <-- Non-regression test for bug 4840 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4840
//
// <-- Short Description -->
// There is a performance problem with the console.
// The more there is text in the console, the slower is the 
// display, with exponential times.

times = []
rmax = 12
IMAX = 50;
JMAX = IMAX;
for run = 1:rmax
  timer();
  for i = 1:IMAX
    for j = 1:JMAX
      mprintf("I=%d, J=%d\n",i,j);
    end
  end
  t = timer();
  times = [times t];
end
times

// The times should be approximatively constant


