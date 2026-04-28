// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2006-2008 - INRIA - Serge Steer <Serge.Steer@scilab.org>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 2850 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2850
//
// <-- Short Description -->
// xpolys performance regression in Scilab 5

// should be almost as fast in Scilab 4 and Scilab 5.

clf();
u=rand(2,10000);
v=rand(2,10000);
timer();
xpolys(u,v);
t1 = timer()
if t1 > 10 then pause, end;
