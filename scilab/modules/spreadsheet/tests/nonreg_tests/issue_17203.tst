// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17203 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17203
//
// <-- Short Description -->
// Some timeseries properties were not updated after data extraction.

T = datetime(2023, 1, 1) + (0:99)';
FlowRate = 101:200;
AmbientTemperature = 1:100;
ts = timeseries(T, AmbientTemperature', FlowRate');

tt = retime(ts(ts.Time > datetime(2023,3,1)), "daily", sum);

tt2 = retime(ts, "daily", sum);

tt3 = tt2(tt2.Time > datetime(2023,3,1));

assert_checkequal(tt3.Properties.StartTime, tt.Properties.StartTime);

