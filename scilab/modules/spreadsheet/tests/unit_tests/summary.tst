// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// unit tests for summary function
// =============================================================================

// table with only doubles
t = table([1 2 3; 4 5 6; 7 8 9]);
summary(t)
s = summary(t)
assert_checkequal(s.Var1.Size, [3 1]);
assert_checkequal(s.Var2.Size, [3 1]);
assert_checkequal(s.Var3.Size, [3 1]);
assert_checkequal(s.Var1.Type, "double");
assert_checkequal(s.Var2.Type, "double");
assert_checkequal(s.Var3.Type, "double");

t.Properties.VariableNames = ["a", "b", "c"];
summary(t)
s = summary(t)
assert_checkequal(fieldnames(s), ["a"; "b"; "c"]);
assert_checkequal(s.a.Size, [3 1]);
assert_checkequal(s.b.Size, [3 1]);
assert_checkequal(s.c.Size, [3 1]);
assert_checkequal(s.a.Type, "double");
assert_checkequal(s.b.Type, "double");
assert_checkequal(s.c.Type, "double");

t.Properties.VariableDescriptions = ["field a", "", "field c"];
summary(t)
s = summary(t)
assert_checkequal(s.a.Description, "field a");
assert_checkequal(s.b.Description, "");
assert_checkequal(s.c.Description, "field c");

t.Properties.VariableUnits = ["h", "mm", "ss"];
summary(t)
s = summary(t)
assert_checkequal(s.a.Units, "h");
assert_checkequal(s.b.Units, "mm");
assert_checkequal(s.c.Units, "ss");

summary(t, ["min", "max", "var"])
s = summary(t, ["min", "max", "var"])
summary(t, "q3")
s = summary(t, "q3")

// table containing doubles, datetimes, durations
t = table([1;2;3], datetime(2025, 12, [10; 11; 12]), hours([1;2;3]));
summary(t)
s = summary(t)
assert_checkequal(s.Var1.Size, [3 1]);
assert_checkequal(s.Var2.Size, [3 1]);
assert_checkequal(s.Var3.Size, [3 1]);

assert_checkequal(s.Var1.Type, "double");
assert_checkequal(s.Var2.Type, "datetime");
assert_checkequal(s.Var3.Type, "duration");

t.Properties.VariableNames = ["a", "b", "c"];
summary(t)
s = summary(t)
assert_checkequal(fieldnames(s), ["a"; "b"; "c"]);
assert_checkequal(s.a.Size, [3 1]);
assert_checkequal(s.b.Size, [3 1]);
assert_checkequal(s.c.Size, [3 1]);
assert_checkequal(s.a.Type, "double");
assert_checkequal(s.b.Type, "datetime");
assert_checkequal(s.c.Type, "duration");

t.Properties.VariableDescriptions = ["", "date time", "hours"];
summary(t)
s = summary(t)
assert_checkequal(s.a.Description, "");
assert_checkequal(s.b.Description, "date time");
assert_checkequal(s.c.Description, "hours");

t.Properties.VariableUnits = ["", "days", "h"];
summary(t)
s = summary(t)
assert_checkequal(s.a.Units, "");
assert_checkequal(s.b.Units, "days");
assert_checkequal(s.c.Units, "h");

summary(t, ["min", "max"])

t = table([%nan; 1; 2; 3], [datetime(2025, 12, [10; 11; 12]); NaT()], hours([1;%nan;2;3]));
summary(t)
s = summary(t)

// table containing doubles and int
t = table([1; 2; 3], int8([1; 2; 3]), uint8([1; 2; 3]));
summary(t)
s = summary(t)
assert_checkequal(s.Var1.Size, [3 1]);
assert_checkequal(s.Var2.Size, [3 1]);
assert_checkequal(s.Var3.Size, [3 1]);

assert_checkequal(s.Var1.Type, "double");
assert_checkequal(s.Var2.Type, "int8");
assert_checkequal(s.Var3.Type, "uint8");

t.Properties.VariableNames = ["a", "b", "c"];
summary(t)
s = summary(t)
assert_checkequal(fieldnames(s), ["a"; "b"; "c"]);
assert_checkequal(s.a.Size, [3 1]);
assert_checkequal(s.b.Size, [3 1]);
assert_checkequal(s.c.Size, [3 1]);
assert_checkequal(s.a.Type, "double");
assert_checkequal(s.b.Type, "int8");
assert_checkequal(s.c.Type, "uint8");

t.Properties.VariableDescriptions = ["double", "integer", "unsigned integer"];
summary(t)
s = summary(t)
assert_checkequal(s.a.Description, "double");
assert_checkequal(s.b.Description, "integer");
assert_checkequal(s.c.Description, "unsigned integer");

summary(t, ["min", "max"])

// table containing booleans and strings
t = table([%t; %f; %t], [%f; %t; %f], ["a"; "b"; "a"], ["b"; "b"; "bb"]);
summary(t)
s = summary(t)
assert_checkequal(s.Var1.Size, [3 1]);
assert_checkequal(s.Var2.Size, [3 1]);
assert_checkequal(s.Var3.Size, [3 1]);
assert_checkequal(s.Var4.Size, [3 1]);

assert_checkequal(s.Var1.Type, "boolean");
assert_checkequal(s.Var2.Type, "boolean");
assert_checkequal(s.Var3.Type, "string");
assert_checkequal(s.Var4.Type, "string");

// timeseries
T = datetime(2022, 12, 1:5)';
AmbientTemperature = [18; 18.5; 20; 20.2; 20.5];
FlowRate = [50; 52; 53; 55; 60];
ts = timeseries(T, AmbientTemperature, FlowRate)
summary(ts)
s = summary(ts)
assert_checkequal(s.Time.Size, [5 1]);
assert_checkequal(s.Var1.Size, [5 1]);
assert_checkequal(s.Var2.Size, [5 1]);
assert_checkequal(s.Time.Type, "datetime");
assert_checkequal(s.Var1.Type, "double");
assert_checkequal(s.Var2.Type, "double");
ts.Properties.VariableNames = ["T", "AmbientTemperature", "FlowRate"];
summary(ts)
s = summary(ts)
assert_checkequal(fieldnames(s), ["T"; "AmbientTemperature"; "FlowRate"]);
assert_checkequal(s.T.Size, [5 1]);
assert_checkequal(s.AmbientTemperature.Size, [5 1]);
assert_checkequal(s.FlowRate.Size, [5 1]);
assert_checkequal(s.T.Type, "datetime");
assert_checkequal(s.AmbientTemperature.Type, "double");
assert_checkequal(s.FlowRate.Type, "double");
