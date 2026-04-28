// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E.
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// Benchmark test for a display of long real vectors
// t2/t1 > 4 on Windows ; t2/t1 > 8 on Linux
// benchmark created from non-regression test bug_16397

// <-- BENCH NB RUN : 1 -->
x=rand(1e4,1);

// <-- BENCH START -->
timer();
disp(x)
t1 = timer();
disp([x,x])
t2 = timer();
t2/t1

// <-- BENCH END -->