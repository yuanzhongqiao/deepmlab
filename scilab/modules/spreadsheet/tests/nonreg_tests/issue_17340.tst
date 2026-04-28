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
// <-- Non-regression test for issue 17340 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17340
//
// <-- Short Description -->
// concatenate tables (or timeseries) with different types now returns an error message

// table
vNames = ["Time", "a", "b", "c"]
t0 = table(zeros(vNames), "VariableNames", vNames);
t1 = t0;
t0.Time = seconds(0);

msg = msprintf(_("%s: Impossible to concatenate ""%s"" column: Same types expected but got ""%s"" and ""%s""."), "%table_f_table", "Time", "duration", "constant");
assert_checkerror("[t0 ; t1]", msg);

// timeseries
ts0 = table2timeseries(t0);
ts1 = timeseries(seconds(2), 1, "2", 3, "VariableNames", vNames);
msg = msprintf(_("%s: Impossible to concatenate ""%s"" column: Same types expected but got ""%s"" and ""%s""."), "%timeseries_f_timeseries", "b", "constant", "string");
assert_checkerror("[ts0 ; ts1]", msg);

ts1 = timeseries(datetime(), 1, 2, 3, "VariableNames", vNames);
msg = msprintf(_("%s: Impossible to concatenate ""%s"" column: Same types expected but got ""%s"" and ""%s""."), "%timeseries_f_timeseries", "Time", "duration", "datetime");
assert_checkerror("[ts0 ; ts1]", msg);