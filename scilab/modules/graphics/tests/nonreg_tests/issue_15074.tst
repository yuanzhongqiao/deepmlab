// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 15074 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15074
//
// <-- Short Description -->
// A simple script cause an abnormal use of memory (>1 Gb)
// Due to a memleak in get(f, "color_map"), addcolor() & color()

nbIter = 1000; // Number of execution of code to create a huge/detectable memleak
tolerance = 100; // Margin for memleak detection

// Allocate a huge color_map (make memleak detection easier)
nbColors = 2^17;
cmapSize = nbColors * 3 /* RBG */ * 8 /* sizeof(double) */ / 1024 /* Kb */;
f = gcf();
f.color_map = jet(nbColors);

// get(f, "color_map") case
freememBefore = getmemory();
for i=1:nbIter
    f.color_map;
end
freememAfter = getmemory();
assert_checktrue((freememBefore - freememAfter) < (cmapSize * tolerance))

// addcolor() case
freememBefore = getmemory();
for i=1:nbIter
    addcolor([0 0 0]);
end
freememAfter = getmemory();
assert_checktrue((freememBefore - freememAfter) < (cmapSize * tolerance))

// color() case
freememBefore = getmemory();
for i=1:nbIter
    color(0, 0, 0);
end
freememAfter = getmemory();
assert_checktrue((freememBefore - freememAfter) < (cmapSize * tolerance))
