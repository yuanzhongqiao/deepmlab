// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2021 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16734 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16734
//
// <-- Short Description -->
// findobj severely degrades run time performance in Scilab 6.1.1

clf
plot();
gce().children(7).tag = "foo";

N=1000;
timer();
for i=1:N
    h = findobj("tag","foo");
end
t = timer()/N;

assert_checktrue(t<1e-4)
