// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Adeline CARNIS
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for pivot function
// =============================================================================

rand("seed", 0)
x1 = floor(rand(5,1)*5)-1.5;
x2 = -floor(rand(5,1)*5)+0.5;
x = ["a"; "b"; "b"; "c"; "a"];
y = ["x"; "x"; "x"; "y"; "y"];

A = table(x, y, x1, x2, "VariableNames", ["x", "y", "v1", "v2"]);

P = pivot(A, Rows="x", Columns="y");

expected = ["a" "1" "1"; "b" "2" "0"; "c" "0" "1"];
varnames = ["Var_x", "x", "y"];
assert_checkequal(P.Properties.VariableNames, varnames);
assert_checkequal(string(P), expected);

P = pivot(A, Rows="x", Columns="y", DataVariable="v2");
expected = ["a" "-2.5" "0.5"; "b" "-6" "0"; "c" "0" "-3.5"];
assert_checkequal(string(P), expected);

P = pivot(A, Rows="x", Columns="y", Method="sum", DataVariable="v1");
expected = ["a" "-0.5" "1.5"; "b" "0" "0"; "c" "0" "-0.5"];
assert_checkequal(string(P), expected);

clear t;
t.FirstName = ["Anna"; "Marius"; "Judith"; "Maria"; "David"; "Chris"; "William"; "George"; "Emmy"; "Liam"];
t.Gender = ["Female"; "Male"; "Female"; "Female"; "Male"; "Male"; "Male"; "Male"; "Female"; "Male"];
t.Age = [7;7;8;7;7;8;8;7;7;8];
t.Sport = ["Tennis"; "Rugby"; "Athelics"; "Athelics"; "Tennis"; "Rugby"; "Rugby"; "Tennis"; "Rugby"; "Rugby"];
t = struct2table(t);

P = pivot(t, Rows="Gender", Columns="Sport");
expected = ["Female" "2" "1" "1"; "Male" "0" "4" "2"];
varnames = ["Gender", "Athelics", "Rugby", "Tennis"];
assert_checkequal(P.Properties.VariableNames, varnames);
assert_checkequal(string(P), expected);

P = pivot(t, Rows="Gender", Columns="Sport", IncludeTotals=%t);
expected = ["Female" "2" "1" "1" "4"; "Male" "0" "4" "2" "6"; "Total" "2" "5" "3" "10"];
varnames = ["Gender", "Athelics", "Rugby", "Tennis", "Total"];
assert_checkequal(P.Properties.VariableNames, varnames);
assert_checkequal(string(P), expected);

P = pivot(t, Rows="Gender", Columns="Sport", Method="mean", DataVariable="Age");
expected = ["Female" "7.5" "7" "7"; "Male" "0" "7.75" "7"];
varnames = ["Gender", "Athelics", "Rugby", "Tennis"];
assert_checkequal(P.Properties.VariableNames, varnames);
assert_checkequal(string(P), expected);

P = pivot(t, Columns="Sport", IncludeTotals=%t);
expected = ["2" "5" "3" "10"];
varnames = ["Athelics", "Rugby", "Tennis", "Total"];
assert_checkequal(P.Properties.VariableNames, varnames);
assert_checkequal(string(P), expected);

P = pivot(t, Rows="Sport", IncludeTotals=%t);
expected = ["Athelics" "2"; "Rugby" "5"; "Tennis" "3"; "Total" "10"];
varnames = ["Sport", "GroupCount"];
assert_checkequal(P.Properties.VariableNames, varnames);
assert_checkequal(string(P), expected);

P = pivot(t, Rows="Age", Columns="Sport");
expected = ["7" "1" "2" "3"; "8" "1" "3" "0"];
varnames = ["Age" "Athelics" "Rugby" "Tennis"];
assert_checkequal(P.Properties.VariableNames, varnames);
assert_checkequal(string(P), expected);

P = pivot(t, Rows="Age", Columns="Sport", Method="percentage");
expected = ["7" "10" "20" "30"; "8" "10" "30" "0"];
assert_checkequal(P.Properties.VariableNames, varnames);
assert_checkequal(string(P), expected);

// With IncludedEdge
// -----------------------------------------------------------------
P = pivot(A, Rows="x", Columns="v1", ColumnsBinMethod=[-1.5 0 1.5]);
expected = ["a" "1" "1"; "b" "1" "1"; "c" "1" "0"];
varnames = ["x", "[-1.5, 0)", "[0, 1.5]"];
assert_checkequal(P.Properties.VariableNames, varnames);
assert_checkequal(string(P), expected);

P = pivot(A, Rows="x", Columns="v1", ColumnsBinMethod=[-1.5 0 1.5], IncludedEdge="right");
expected = ["a" "1" "1"; "b" "1" "1"; "c" "1" "0"];
varnames = ["x", "[-1.5, 0]", "(0, 1.5]"];
assert_checkequal(P.Properties.VariableNames, varnames);
assert_checkequal(string(P), expected);

P = pivot(A, Rows="v1", Columns="x", RowsBinMethod=[-1.5 0 1.5]);
expected = ["[-1.5, 0)" "1" "1" "1"; "[0, 1.5]" "1" "1" "0"];
varnames = ["v1", "a", "b", "c"];
assert_checkequal(P.Properties.VariableNames, varnames);
assert_checkequal(string(P), expected);

P = pivot(A, Rows="v1", Columns="x", RowsBinMethod=[-1.5 0 1.5], IncludedEdge="right");
expected = ["[-1.5, 0]" "1" "1" "1"; "(0, 1.5]" "1" "1" "0"];
varnames = ["v1", "a", "b", "c"];
assert_checkequal(P.Properties.VariableNames, varnames);
assert_checkequal(string(P), expected);

// -----------------------------------------------------------------
clear t;
t.time = [1;1;2;2];
t.location = ["indoors"; "outdoors"; "indoors"; "outdoors"];
t.data = [24;18;25;19];
T = struct2table(t);

P = pivot(T, Rows="time", Columns="location");
assert_checkequal(string(P), ["1" "1" "1"; "2" "1" "1"]);

P = pivot(T, Rows="time", Columns="location", DataVariable="data");
assert_checkequal(string(P), ["1" "24" "18"; "2" "25" "19"]);

clear t
v1 = ["v1"; "v1"; "v1"; "v2"; "v2"; "v2"];
v2 = ["a1"; "a1"; "a2"; "a2"; "a3"; "a3"];
v3 = ["b1"; "b2"; "b1"; "b2"; "b1"; "b2"];
v4 = [1; 1; 1; 2; 2; 2];
t = table(v1, v2, v3, v4, "VariableNames", ["v1", "v2", "v3", "v4"]);

p = pivot(t, Rows=["v1", "v2"]);
assert_checkequal(p, table(["v1"; "v1"; "v2"; "v2"], ["a1"; "a2"; "a2"; "a3"], [2; 1; 1; 2], "VariableNames", ["v1", "v2", "GroupCount"]));

p = pivot(t, Rows=["v1", "v2"], DataVariable="v4", Method="sum");
assert_checkequal(p, table(["v1"; "v1"; "v2"; "v2"], ["a1"; "a2"; "a2"; "a3"], [2; 1; 2; 4], "VariableNames", ["v1", "v2", "sum_v4"]));

ts = table2timeseries(t, "RowTimes", hours(1:6)');
fc = #(x) ->(mean(x));
p = pivot(ts, Rows="Time", RowsBinMethod=hours(3), Method=fc, DataVariable="v4");
expected = table(["[ 00:00:00, 03:00:00 )"; "[ 03:00:00, 06:00:00 ]"], [1; 1.75], "VariableNames", ["Time", "fun_v4"]);
assert_checkequal(p, expected);

ts = table2timeseries(t, "RowTimes", [datetime(2025, 1, 1):datetime(2025, 1, 6)]');
p = pivot(ts, Rows="Time", RowsBinMethod=caldays(2), Method=fc, DataVariable="v4");
expected = table(["[ 2025-01-01, 2025-01-03 )"; "[ 2025-01-03, 2025-01-05 )"; "[ 2025-01-05, 2025-01-07 ]"], [1; 1.5; 2], "VariableNames", ["Time", "fun_v4"]);
assert_checkequal(p, expected);

p = pivot(ts, Rows="Time", RowsBinMethod=[ts.Time(1); ts.Time(3); ts.Time($)], Method=fc, DataVariable="v4");
expected = table(["[ 2025-01-01, 2025-01-03 )"; "[ 2025-01-03, 2025-01-06 ]"], [1; 1.75], "VariableNames", ["Time", "fun_v4"]);
assert_checkequal(p, expected);

p = pivot(ts, Rows="Time", RowsBinMethod={[ts.Time(1); ts.Time(3); ts.Time($)]}, Method=fc, DataVariable="v4");
assert_checkequal(p, expected);