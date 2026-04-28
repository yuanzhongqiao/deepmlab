// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Adeline CARNIS
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for groupsummary function
// =============================================================================

rand("seed", 0)
x1 = floor(rand(5,1)*5)-1.5;
x2 = -floor(rand(5,1)*5)+0.5;
A = table(["a"; "b"; "b"; "c"; "a"], x1, x2, "VariableNames", ["x", "x1", "x2"]);

G = groupsummary(A, "x");
expected = ["a" "2"; "b" "2"; "c" "1"];
assert_checkequal(G.Properties.VariableNames, ["x", "GroupCount"]);
assert_checkequal(string(G), expected);


expected = ["a" "2" "1" "-2"; "b" "2" "0" "-6"; "c" "1" "-0.5" "-3.5"];
varnames = ["x", "GroupCount", "fun_x1", "fun_x2"];
G = groupsummary(A, "x", sum);
assert_checkequal(G.Properties.VariableNames, varnames);
assert_checkequal(string(G), expected);

varnames = ["x", "GroupCount", "sum_x1", "sum_x2"];
G = groupsummary(A, "x", "sum");
assert_checkequal(G.Properties.VariableNames, varnames);
assert_checkequal(string(G), expected);


varnames = ["x", "GroupCount", "fun1_x1", "fun1_x2", "fun2_x1", "fun2_x2"];
expected = ["a" "2" "1" "-2" "1.5" "0.5"; ...
            "b" "2" "0" "-6" "1.5" "-2.5"; ...
            "c" "1" "-0.5" "-3.5" "-0.5" "-3.5"];

G = groupsummary(A, "x", {sum, max});
assert_checkequal(G.Properties.VariableNames, varnames);
assert_checkequal(string(G), expected);

G = groupsummary(A, "x", {"sum", "max"});
varnames = ["x", "GroupCount", "sum_x1", "sum_x2", "max_x1", "max_x2"];
assert_checkequal(G.Properties.VariableNames, varnames);
assert_checkequal(string(G), expected);

G = groupsummary(A, "x", {sum, "max"});
varnames = ["x", "GroupCount", "fun1_x1", "fun1_x2", "max_x1", "max_x2"];
assert_checkequal(G.Properties.VariableNames, varnames);
assert_checkequal(string(G), expected);

G = groupsummary(A, "x", {"sum", max});
varnames = ["x", "GroupCount", "sum_x1", "sum_x2", "fun2_x1", "fun2_x2"];
assert_checkequal(G.Properties.VariableNames, varnames);
assert_checkequal(string(G), expected);


expected = ["a" "2" "1"; "b" "2" "0"; "c" "1" "-0.5"];
varnames = ["x", "GroupCount", "fun_x1"];

G = groupsummary(A, "x", sum, "x1");
assert_checkequal(G.Properties.VariableNames, varnames);
assert_checkequal(string(G), expected);

G = groupsummary(A, "x", "sum", "x1");
varnames = ["x", "GroupCount", "sum_x1"];
assert_checkequal(G.Properties.VariableNames, varnames);
assert_checkequal(string(G), expected);


varnames = ["x", "GroupCount", "fun1_x1", "fun2_x1"];
expected = ["a" "2" "1" "1.5"; ...
            "b" "2" "0" "1.5"; ...
            "c" "1" "-0.5" "-0.5"];

G = groupsummary(A, "x", {sum, max}, "x1");
assert_checkequal(G.Properties.VariableNames, varnames);
assert_checkequal(string(G), expected);

G = groupsummary(A, "x", {"sum", "max"}, "x1");
varnames = ["x", "GroupCount", "sum_x1", "max_x1"];
assert_checkequal(G.Properties.VariableNames, varnames);
assert_checkequal(string(G), expected);

G = groupsummary(A, "x", {sum, "max"}, "x1");
varnames = ["x", "GroupCount", "fun1_x1", "max_x1"];
assert_checkequal(G.Properties.VariableNames, varnames);
assert_checkequal(string(G), expected);

G = groupsummary(A, "x", {"sum", max}, "x1");
varnames = ["x", "GroupCount", "sum_x1", "fun2_x1"];
assert_checkequal(G.Properties.VariableNames, varnames);
assert_checkequal(string(G), expected);


G = groupsummary(A, "x1", [-3 -1 1 3]);
varnames = ["disc_x1", "GroupCount"];
expected = ["[-3, -1)" "1"; "[-1, 1)" "2"; "[1, 3]" "2"];
assert_checkequal(G.Properties.VariableNames, varnames);
assert_checkequal(string(G), expected);

G = groupsummary(A, "x1", [-3 -1 1 3], sum, "x2");
varnames = ["disc_x1", "GroupCount", "fun_x2"];
expected = ["[-3, -1)" "1" "-2.5"; "[-1, 1)" "2" "-6"; "[1, 3]" "2" "-3"];
assert_checkequal(G.Properties.VariableNames, varnames);
assert_checkequal(string(G), expected);

G = groupsummary(A, ["x1", "x2"], [-5 0 5]);
varnames = ["disc_x1", "disc_x2", "GroupCount"];
expected = ["[-5, 0)" "[-5, 0)" "3"; "[0, 5]" "[-5, 0)" "1"; "[0, 5]" "[0, 5]" "1"];
assert_checkequal(G.Properties.VariableNames, varnames);
assert_checkequal(string(G), expected);

// With IncludedEdge - right
G = groupsummary(A, "x1", [-1.5 -0.5 0.5 1.5], "IncludedEdge", "right");
varnames = ["disc_x1", "GroupCount"];
expected = ["[-1.5, -0.5]" "3"; "(0.5, 1.5]" "2"];
assert_checkequal(G.Properties.VariableNames, varnames);
assert_checkequal(string(G), expected);

G = groupsummary(A, "x1", [-1.5 -0.5 0.5 1.5], sum, "x2", "IncludedEdge", "right");
varnames = ["disc_x1", "GroupCount", "fun_x2"];
expected = ["[-1.5, -0.5]" "3" "-8.5"; "(0.5, 1.5]" "2" "-3"];
assert_checkequal(G.Properties.VariableNames, varnames);
assert_checkequal(string(G), expected);

G = groupsummary(A, ["x1", "x2"], {[-1.5 -0.5 0.5 1.5], [-4 -1.5 0 1.5]}, "IncludedEdge", "right");
varnames = ["disc_x1", "disc_x2", "GroupCount"];
expected = ["[-1.5, -0.5]" "[-4, -1.5]" "3"; "(0.5, 1.5]" "[-4, -1.5]" "1"; "(0.5, 1.5]" "(0, 1.5]" "1"];
assert_checkequal(G.Properties.VariableNames, varnames);
assert_checkequal(string(G), expected);

// Test case-sensitivity on options
assert_checktrue(execstr("groupsummary(A, ""x1"", [-1.5 -0.5 0.5 1.5], ""includededge"", ""right"")", "errcatch") == 0);
assert_checktrue(execstr("groupsummary(A, ""x1"", [-1.5 -0.5 0.5 1.5], ""InClUdededGe"", ""right"")", "errcatch") == 0);


timestamp = hours([1 3 2 2 3])';
A = timeseries(timestamp, x1, x2, "VariableNames", ["hours", "x1", "x2"]);

G = groupsummary(A, "hours", sum);
expected = [string(hours(1:3))' string([1;2;2]), string([-0.5;-2; 3]), string([-2.5; -6; -3])];
assert_checkequal(G.Properties.VariableNames, ["hours", "GroupCount", "fun_x1", "fun_x2"]);
assert_checkequal(string(G), expected);


// -----------------------------------------------------------------------------
// Data from www.historique-meteo.net
T = readtable(fullfile(SCI, "modules", "spreadsheet", "tests", "unit_tests","meteo_data_bordeaux.csv"));

G = groupsummary(T, "OPINION", {max, mean}, ["MAX_TEMPERATURE_C", "MIN_TEMPERATURE_C", "SUNHOUR"]);

expected = ["météo correcte" "7" "25" "19" "13.5" "23" "17.714286" "12.371429"; ...
            "météo défavorable" "3" "26" "18" "11.5" "23" "17.333333" "10.233333"; ...
            "météo favorable" "10" "31" "19" "14.5" "25.6" "17.5" "13.3"; ...
            "météo idéale" "10" "31" "19" "14.5" "26.7" "17.8" "14.2"];
assert_checkequal(G.Properties.VariableNames, ["OPINION" "GroupCount", "fun1_MAX_TEMPERATURE_C", "fun1_MIN_TEMPERATURE_C", "fun1_SUNHOUR", "fun2_MAX_TEMPERATURE_C", "fun2_MIN_TEMPERATURE_C", "fun2_SUNHOUR"]);
assert_checkequal(string(G), expected);


d = [datetime(2023, 1, 1): caldays(15): datetime(2023, 6, 15)]';
s = size(d, "*");
v1 = [1; 4; 3; 5; 3; 3; 3; 5; 2; 5; 2; 5];
v2 = ["B"; "B"; "A"; "A"; "C"; "C"; "C"; "A"; "B"; "B"; "B"; "C"];
v3 = ["B"; "A"; "A"; "C"; "C"; "B"; "C"; "B"; "B"; "A"; "B"; "A"];
ts = timeseries(d, v1, v2, v3, "VariableNames", ["Time", "value", "string1", "string2"]);

function r = findA(x)
    ind = find(x == "A");
    r = sum(ind)
endfunction

function r = findB(x)
    ind = find(x == "B");
    r = sum(ind)
endfunction

function r = findC(x)
    ind = find(x == "C");
    r = sum(ind)
endfunction

g = groupsummary(ts, "Time", "month", findA, "string1");
assert_checkequal(g.fun_string1, [3; 1; 0; 2; 0; 0]);
g = groupsummary(ts, "Time", "month", {findA, findB, findC}, "string1");
expected = [3 3 0; 1 0 0; 0 0 3; 2 0 1; 0 6 0; 0 0 1];
assert_checkequal(g(["fun1_string1", "fun2_string1", "fun3_string1"]), expected);
g = groupsummary(ts, "Time", "month", {findA, findB, findC}, ["string1", "string2"]);
expected = [3 5 3 1 0 0; 1 0 0 0 0 1; 0 0 0 2 3 1; 2 0 0 2 1 1; 0 2 6 4 0 0; 0 1 0 0 1 0];
assert_checkequal(g(["fun1_string1", "fun1_string2","fun2_string1", "fun2_string2", "fun3_string1", "fun3_string2"]), expected);

d = datetime(2024, 4, [1; 5; 8; 2; 3; 6; 4; 12; 9; 11; 10; 7])
v1 = [1; 4; 3; 5; 3; 3; 3; 5; 2; 5; 2; 5];
v2 = ["B"; "B"; "A"; "A"; "C"; "C"; "C"; "A"; "B"; "B"; "B"; "C"];
v3 = ["B"; "A"; "A"; "C"; "C"; "B"; "C"; "B"; "B"; "A"; "B"; "A"];
ts = timeseries(d, v1, v2, v3, "VariableNames", ["Time", "value", "string1", "string2"]);

g = groupsummary(ts, "Time", datetime(2024, 4, 5:9), "sum", "value");
dtime = ["[ 2024-04-05, 2024-04-06 )"; "[ 2024-04-06, 2024-04-07 )"; "[ 2024-04-07, 2024-04-08 )"; "[ 2024-04-08, 2024-04-09 ]"];
expected = table(dtime, [1; 1; 1; 2], [4; 3; 5; 5], "VariableNames", ["Time", "GroupCount", "sum_value"]);
assert_checkequal(g, expected);
g = groupsummary(ts, "Time", datetime(2024, 4, 5:9), sum, "value");
expected = table(dtime, [1; 1; 1; 2], [4; 3; 5; 5], "VariableNames", ["Time", "GroupCount", "fun_value"]);
assert_checkequal(g, expected);