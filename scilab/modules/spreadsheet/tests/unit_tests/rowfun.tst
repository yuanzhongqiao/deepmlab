// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Adeline CARNIS
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for rowfun function
// =============================================================================

rand("seed", 0)
x1 = floor(rand(5,1)*5)-1.5;
x2 = -floor(rand(5,1)*5)+0.5;
A = table(x1, x2, "VariableNames", ["x1", "x2"]);

function res = f(x, y)
    res = x + y;
endfunction

R = rowfun(f, A);
assert_checkequal(R.Var1, x1+x2);

function res = f2(x, y)
    res = diag(cov(x, y))
endfunction

R = rowfun(f2, A);
assert_checkequal(R.Var1, diag(cov(x1, x2)));

// -----------------------------------------------------------------------------
// With InputVariables
x3 = floor(rand(5,1)*5)+1;
A.x3 = x3;
R = rowfun(f, A, "InputVariables", ["x1", "x3"]);
assert_checkequal(R.Properties.VariableNames, "Var1");
assert_checkequal(R.Var1, x1+x3);

R = rowfun(f2, A, "InputVariables", ["x2", "x3"]);
assert_checkequal(R.Var1, diag(cov(x2, x3)));

// -----------------------------------------------------------------------------
// With OutputVariableNames
R = rowfun(f, A, "InputVariables", ["x1", "x3"], "OutputVariableNames", "result");
assert_checkequal(R.Properties.VariableNames, "result");
assert_checkequal(R.result, x1+x3);

function [v, w, z] = f3(x, y)
    v = x + y;
    w = x - y;
    z = x .* y;
endfunction

R = rowfun(f3, A, "InputVariables", ["x1", "x3"], "OutputVariableNames", ["v", "w", "z"]);
assert_checkequal(R.Properties.VariableNames, ["v", "w", "z"]);
assert_checkequal(R.v, x1+x3);
assert_checkequal(R.w, x1-x3);
assert_checkequal(R.z, x1.*x3);

// -----------------------------------------------------------------------------
// With GroupingVariables
A.x4 = ["a"; "b"; "b"; "c"; "a"];
R = rowfun(f, A, "GroupingVariables", "x4", "InputVariables", ["x1", "x3"]);
assert_checkequal(R.Properties.VariableNames, ["x4", "GroupCount", "Var1"]);
expected = [x1([1 5]) + x3([1 5]); x1([2 3]) + x3([2 3]); x1(4) + x3(4)];
assert_checkequal(R.Var1, expected);

// -----------------------------------------------------------------------------
// With NumOutputs
R = rowfun(f3, A, "InputVariables", ["x1", "x3"], "NumOutputs", 3);
assert_checkequal(R.Properties.VariableNames, ["Var1", "Var2", "Var3"]);
assert_checkequal(R.Var1, x1+x3);
assert_checkequal(R.Var2, x1-x3);
assert_checkequal(R.Var3, x1.*x3);

// -----------------------------------------------------------------------------
// Calling with timeseries
dura = hours([1 3 2 2 3])';
A = timeseries(dura, x1, x2, "VariableNames", ["hours", "x1", "x2"]);

R = rowfun(f, A);
assert_checkequal(R.Properties.VariableNames, ["hours", "Var1"]);
assert_checkequal(R.Var1, x1+x2);

A.x3 = x3;
R = rowfun(f, A, "InputVariables", ["x1", "x3"]);
assert_checkequal(R.Properties.VariableNames, ["hours", "Var1"]);
assert_checkequal(R.Var1, x1+x3);

R = rowfun(f, A, "InputVariables", ["x1", "x3"], "OutputVariableNames", "result");
assert_checkequal(R.Properties.VariableNames, ["hours", "result"]);
assert_checkequal(R.result, x1+x3);

R = rowfun(f3, A, "InputVariables", ["x1", "x3"], "OutputVariableNames", ["v", "w", "z"]);
assert_checkequal(R.Properties.VariableNames, ["hours", "v", "w", "z"]);
assert_checkequal(R.v, x1+x3);
assert_checkequal(R.w, x1-x3);
assert_checkequal(R.z, x1.*x3);

R = rowfun(f, A, "GroupingVariables", "hours", "InputVariables", ["x1", "x3"]);
assert_checkequal(R.Properties.VariableNames, ["hours", "GroupCount", "Var1"]);
expected = [x1(1) + x3(1); x1([3 4]) + x3([3 4]); x1([2 5])+x3([2 5])];
assert_checkequal(R.Var1, expected);

A.x4 = ["a"; "b"; "b"; "c"; "a"];
R = rowfun(f, A, "GroupingVariables", "x4", "InputVariables", ["x1", "x3"], "OutputVariableNames", "z");
assert_checkequal(R.Properties.VariableNames, ["hours", "x4", "GroupCount", "z"]);
expected = [x1([1 5]) + x3([1 5]); x1([2 3]) + x3([2 3]); x1(4) + x3(4)];
assert_checkequal(R.z, expected);


// -----------------------------------------------------------------------------
// Data from www.historique-meteo.net
function r = f(x, y)
    r = x - y;
endfunction

T = readtable(fullfile(SCI, "modules", "spreadsheet", "tests", "unit_tests","meteo_data_bordeaux.csv"));
R = rowfun(f, T, "InputVariables", ["MAX_TEMPERATURE_C", "MIN_TEMPERATURE_C"], "OutputVariableNames", "res");
assert_checkequal(R.Properties.VariableNames, "res");
assert_checkequal(R.res, T.MAX_TEMPERATURE_C - T.MIN_TEMPERATURE_C);

M = rand(6,1);
d = hours(M);
t = table([0;1;2] .*. [1;1], d, M, "VariableNames", ["id", "execTimeDuration", "execTimeDouble"]);

r = rowfun(mean, t, "InputVariables", "execTimeDouble", "GroupingVariables", "id");
expected = table([0;1;2], [2;2;2], [mean(M(1:2)); mean(M(3:4)); mean(M(5:6))], "VariableNames", ["id", "GroupCount", "Var1"]);
assert_checkequal(r, expected);

r = rowfun(mean, t, "InputVariables", "execTimeDuration", "GroupingVariables", "id")
expected = table([0;1;2], [2;2;2], [mean(d(1:2)); mean(d(3:4)); mean(d(5:6))], "VariableNames", ["id", "GroupCount", "Var1"]);
assert_checkequal(r, expected);

// Test case-sensitivity on options
assert_checktrue(execstr("rowfun(mean, t, ""inPUtvariABles"", ""execTimeDuration"", ""grouPINGvarIAbles"", ""id"")", "errcatch") == 0);
assert_checktrue(execstr("rowfun(f, A, ""gROUpINGvariableS"", ""x4"", ""inputvariables"", [""x1"", ""x3""], ""OUTputVARiablenames"", ""z"")", "errcatch") == 0);
assert_checktrue(execstr("rowfun(f3, A, ""InputVariables"", [""x1"", ""x3""], ""numOUTputs"", 3)", "errcatch") == 0);
