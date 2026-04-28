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
// <-- Non-regression test for issue 17221 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17221
//
// <-- Short Description -->
// synchronize returned wrong results - table2timeseries with table containing Time variable failed

d = datetime(2024, 2, 19, 10, [23; 24; 24; 24], 0);
var17 = [0; 6; 6; 5.5];
ts1 = timeseries(d, var17, "VariableNames", ["Date_and_time", "Var17"]);

d = hours(1:4)';
var6 = ["0w"; "1w"; "2w"; "3w"];
t = table(var6, d, "VariableNames", ["Var6", "Time"]);

time = datetime(2024, 2, 19, 10, 24, [4; 9; 14; 19]);
ts2 = table2timeseries(t, "RowTimes", time);
ts2.Time = [];

newTimes = datetime(2024,2, 19, 10, [23;24;24;24;24;24], [0;0;4;9;14;19]);
r = retime(ts1, newTimes);
assert_checkequal(r.Properties.VariableNames, ["Date_and_time", "Var17"]);
assert_checkequal(r("Date_and_time"), newTimes);
assert_checkequal(r("Var17"), [0; 6; %nan; %nan; %nan; %nan]);

s = synchronize(ts1, ts2);
assert_checkequal(s.Properties.VariableNames, ["Date_and_time", "Var17", "Var6"]);
assert_checkequal(s("Date_and_time"), newTimes);
assert_checkequal(s("Var17"), [0; 6; %nan; %nan; %nan; %nan]);
assert_checkequal(s("Var6"), ["<undefined>"; "<undefined>"; "0w"; "1w"; "2w"; "3w"]);