// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17512 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17512
//
// <-- Short Description -->
// fix comparison between datetime and NaT

dt = datetime();
assert_checkfalse(dt < NaT());
assert_checkfalse(dt <= NaT());
assert_checkfalse(dt > NaT());
assert_checkfalse(dt >= NaT());

dt=datetime([2025 12 16 10 0 1;2025 12 16 10 0 2;2025 12 16 10 0 3;2025 12 16 10 0 4;2025 12 16 10 0 5;]);
dtc= dt+ duration(0,0,2);
dt($)=NaT();
ts=timeseries(dt,[5:9]');
tsc=timeseries(dtc,[4:8]');
errmsg = msprintf("%s: New time vector cannot contain missing times.\n", "synchronize");
assert_checkerror("synchronize(ts,tsc,""regular"",""linear"",""Timestep"",duration(0,0,0.5));", errmsg);
