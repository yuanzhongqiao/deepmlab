// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for addvars function
// =============================================================================

// With table
var_double = [10; 20; 30];
var_string = ["a"; "b"; "c"];
var_boolean = [%t; %f; %t];
var_dura = hours([1; 2; 3]);
var_dt = datetime(2025,1,8:10)';

t = table([1;2;3], ["A";"B";"C"]);
t2 = addvars(t, var_double, var_string, var_boolean, var_dura, var_dt);
assert_checkequal(size(t2), [3 7]);
assert_checkequal(t2.Var3, var_double);
assert_checkequal(t2.Var4, var_string);
assert_checkequal(t2.Var5, var_boolean);
assert_checkequal(t2.Var6, var_dura);
assert_checkequal(t2.Var7, var_dt);

t2 = addvars(t, var_double, var_string, var_boolean, var_dura, var_dt, "NewVariableNames", ["Double", "String", "Bool", "Dura", "Dt"]);
assert_checkequal(t2.Properties.VariableNames, ["Var1", "Var2", "Double", "String", "Bool", "Dura", "Dt"]);

// Before
t2 = addvars(t, var_double, var_string, var_boolean, var_dura, var_dt, "Before", "Var1");
assert_checkequal(size(t2), [3 7]);
assert_checkequal(t2.Properties.VariableNames, "Var" + string([3:7 1 2]));
assert_checkequal(t2.Var3, var_double);
assert_checkequal(t2.Var4, var_string);
assert_checkequal(t2.Var5, var_boolean);
assert_checkequal(t2.Var6, var_dura);
assert_checkequal(t2.Var7, var_dt);

t2 = addvars(t, var_double, var_string, var_boolean, var_dura, var_dt, "Before", "Var2");
assert_checkequal(size(t2), [3 7]);
assert_checkequal(t2.Properties.VariableNames, "Var" + string([1 3:7 2]));
assert_checkequal(t2.Var3, var_double);
assert_checkequal(t2.Var4, var_string);
assert_checkequal(t2.Var5, var_boolean);
assert_checkequal(t2.Var6, var_dura);
assert_checkequal(t2.Var7, var_dt);

l = list(var_double, var_string, var_boolean, var_dura, var_dt);
str = ["Var3", "Var4", "Var5", "Var6", "Var7"];
t = table([1;2;3], ["A";"B";"C"]);
for i = 1:5
    t = addvars(t, l(i), "Before", "Var"+ string(i+1));
    assert_checkequal(t, table([1;2;3], l(i:-1:1), ["A";"B"; "C"], "VariableNames", ["Var1", str(i:-1:1) "Var2"]));
end

t = table([1 2;3 4; 5 6], "VariableNames", ["x1", "x2"]);
str = ["d", "s", "b", "dura", "dt"];
for i = 1:5
    t = addvars(t, l(i), "Before", "x2", "NewVariableNames", str(i));
    assert_checkequal(t, table([1;3;5], l(1:i), [2;4;6], "VariableNames", ["x1", str(1:i) "x2"]));
end

t = table([1;2;3], ["A";"B";"C"]);
t2 = addvars(t, var_double, var_string, var_boolean, var_dura, var_dt, "Before", 1);
assert_checkequal(size(t2), [3 7]);
assert_checkequal(t2.Properties.VariableNames, "Var" + string([3:7 1 2]));
assert_checkequal(t2.Var3, var_double);
assert_checkequal(t2.Var4, var_string);
assert_checkequal(t2.Var5, var_boolean);
assert_checkequal(t2.Var6, var_dura);
assert_checkequal(t2.Var7, var_dt);

t2 = addvars(t, var_double, var_string, var_boolean, var_dura, var_dt, "Before", 2);
assert_checkequal(size(t2), [3 7]);
assert_checkequal(t2.Properties.VariableNames, "Var" + string([1 3:7 2]));
assert_checkequal(t2.Var3, var_double);
assert_checkequal(t2.Var4, var_string);
assert_checkequal(t2.Var5, var_boolean);
assert_checkequal(t2.Var6, var_dura);
assert_checkequal(t2.Var7, var_dt);

l = list(var_double, var_string, var_boolean, var_dura, var_dt);
str = ["Var3", "Var4", "Var5", "Var6", "Var7"];
t = table([1;2;3], ["A";"B";"C"]);
for i = 1:5
    t = addvars(t, l(i), "Before", i+1);
    assert_checkequal(t, table([1;2;3], l(1:i), ["A";"B"; "C"], "VariableNames", ["Var1", str(1:i) "Var2"]));
end

t = table([1 2;3 4; 5 6], "VariableNames", ["x1", "x2"]);
str = ["d", "s", "b", "dura", "dt"];
for i = 1:5
    t = addvars(t, l(i), "Before", size(t, 2), "NewVariableNames", str(i));
    assert_checkequal(t, table([1;3;5], l(1:i), [2;4;6], "VariableNames", ["x1", str(1:i) "x2"]));
end

// After
t = table([1;2;3], ["A";"B";"C"]);
t2 = addvars(t, var_double, var_string, var_boolean, var_dura, var_dt, "After", "Var1");
assert_checkequal(size(t2), [3 7]);
assert_checkequal(t2.Properties.VariableNames, "Var" + string([1 3:7 2]));
assert_checkequal(t2.Var3, var_double);
assert_checkequal(t2.Var4, var_string);
assert_checkequal(t2.Var5, var_boolean);
assert_checkequal(t2.Var6, var_dura);
assert_checkequal(t2.Var7, var_dt);

l = list(var_double, var_string, var_boolean, var_dura, var_dt);
str = ["Var3", "Var4", "Var5", "Var6", "Var7"];
t = table([1;2;3], ["A";"B";"C"]);
for i = 1:5
    t = addvars(t, l(i), "After", "Var"+ string(i+1));
    assert_checkequal(t, table([1;2;3], ["A";"B"; "C"], l(1:i), "VariableNames", ["Var1" "Var2" str(1:i)]));
end

t = table([1 2;3 4; 5 6], "VariableNames", ["x1", "x2"]);
str = ["d", "s", "b", "dura", "dt"];
for i = 1:5
    t = addvars(t, l(i), "After", "x1", "NewVariableNames", str(i));
    assert_checkequal(t, table([1;3;5], l(i:-1:1), [2;4;6], "VariableNames", ["x1", str(i:-1:1) "x2"]));
end

// With timeseries
dt = datetime(2025, 1, [1:3]');
ts = timeseries(dt, [1;2;3], ["A";"B";"C"]);
t2 = addvars(ts, var_double, var_string, var_boolean, var_dura, var_dt);
assert_checkequal(size(t2), [3 7]);
assert_checkequal(t2.Var3, var_double);
assert_checkequal(t2.Var4, var_string);
assert_checkequal(t2.Var5, var_boolean);
assert_checkequal(t2.Var6, var_dura);
assert_checkequal(t2.Var7, var_dt);

t2 = addvars(ts, var_double, var_string, var_boolean, var_dura, var_dt, "NewVariableNames", ["Double", "String", "Bool", "Dura", "Dt"]);
assert_checkequal(t2.Properties.VariableNames, ["Time", "Var1", "Var2", "Double", "String", "Bool", "Dura", "Dt"]);

t2 = addvars(ts, var_double, var_string, var_boolean, var_dura, var_dt, "NewVariableNames", {"Double", "String", "Bool", "Dura", "Dt"});
assert_checkequal(t2.Properties.VariableNames, ["Time", "Var1", "Var2", "Double", "String", "Bool", "Dura", "Dt"]);

// Before
t2 = addvars(ts, var_double, var_string, var_boolean, var_dura, var_dt, "Before", "Var1");
assert_checkequal(size(t2), [3 7]);
assert_checkequal(t2.Properties.VariableNames, ["Time", "Var" + string([3:7 1 2])]);
assert_checkequal(t2.Var3, var_double);
assert_checkequal(t2.Var4, var_string);
assert_checkequal(t2.Var5, var_boolean);
assert_checkequal(t2.Var6, var_dura);
assert_checkequal(t2.Var7, var_dt);

t2 = addvars(ts, var_double, var_string, var_boolean, var_dura, var_dt, "Before", "Var2");
assert_checkequal(size(t2), [3 7]);
assert_checkequal(t2.Properties.VariableNames, ["Time" "Var" + string([1 3:7 2])]);
assert_checkequal(t2.Var3, var_double);
assert_checkequal(t2.Var4, var_string);
assert_checkequal(t2.Var5, var_boolean);
assert_checkequal(t2.Var6, var_dura);
assert_checkequal(t2.Var7, var_dt);

l = list(var_double, var_string, var_boolean, var_dura, var_dt);
str = ["Var3", "Var4", "Var5", "Var6", "Var7"];
ts = timeseries(dt, [1;2;3], ["A";"B";"C"]);
for i = 1:5
    ts = addvars(ts, l(i), "Before", "Var"+ string(i+1));
    assert_checkequal(ts, timeseries(dt, [1;2;3], l(i:-1:1), ["A";"B"; "C"], "VariableNames", ["Time", "Var1", str(i:-1:1) "Var2"]));
end

ts = timeseries(dt, [1 2;3 4; 5 6], "VariableNames", ["Time", "x1", "x2"]);
str = ["d", "s", "b", "dura", "dt"];
for i = 1:5
    ts = addvars(ts, l(i), "Before", "x2", "NewVariableNames", str(i));
    assert_checkequal(ts, timeseries(dt, [1;3;5], l(1:i), [2;4;6], "VariableNames", ["Time", "x1", str(1:i) "x2"]));
end

ts = timeseries(dt, [1;2;3], ["A";"B";"C"]);
t2 = addvars(ts, var_double, var_string, var_boolean, var_dura, var_dt, "Before", 1);
assert_checkequal(size(t2), [3 7]);
assert_checkequal(t2.Properties.VariableNames, ["Time", "Var" + string([3:7 1 2])]);
assert_checkequal(t2.Var3, var_double);
assert_checkequal(t2.Var4, var_string);
assert_checkequal(t2.Var5, var_boolean);
assert_checkequal(t2.Var6, var_dura);
assert_checkequal(t2.Var7, var_dt);

t2 = addvars(ts, var_double, var_string, var_boolean, var_dura, var_dt, "Before", 2);
assert_checkequal(size(t2), [3 7]);
assert_checkequal(t2.Properties.VariableNames, ["Time", "Var" + string([1 3:7 2])]);
assert_checkequal(t2.Var3, var_double);
assert_checkequal(t2.Var4, var_string);
assert_checkequal(t2.Var5, var_boolean);
assert_checkequal(t2.Var6, var_dura);
assert_checkequal(t2.Var7, var_dt);

l = list(var_double, var_string, var_boolean, var_dura, var_dt);
str = ["Var3", "Var4", "Var5", "Var6", "Var7"];
ts = timeseries(dt, [1;2;3], ["A";"B";"C"]);
for i = 1:5
    ts = addvars(ts, l(i), "Before", i+1);
    assert_checkequal(ts, timeseries(dt, [1;2;3], l(1:i), ["A";"B"; "C"], "VariableNames", ["Time", "Var1", str(1:i) "Var2"]));
end

ts = timeseries(dt, [1 2;3 4; 5 6], "VariableNames", ["Time", "x1", "x2"]);
str = ["d", "s", "b", "dura", "dt"];
for i = 1:5
    ts = addvars(ts, l(i), "Before", size(ts, 2), "NewVariableNames", str(i));
    assert_checkequal(ts, timeseries(dt, [1;3;5], l(1:i), [2;4;6], "VariableNames", ["Time", "x1", str(1:i) "x2"]));
end

// After
ts = timeseries(dt, [1;2;3], ["A";"B";"C"]);
t2 = addvars(ts, var_double, var_string, var_boolean, var_dura, var_dt, "After", "Var1");
assert_checkequal(size(t2), [3 7]);
assert_checkequal(t2.Properties.VariableNames, ["Time", "Var" + string([1 3:7 2])]);
assert_checkequal(t2.Var3, var_double);
assert_checkequal(t2.Var4, var_string);
assert_checkequal(t2.Var5, var_boolean);
assert_checkequal(t2.Var6, var_dura);
assert_checkequal(t2.Var7, var_dt);

l = list(var_double, var_string, var_boolean, var_dura, var_dt);
str = ["Var3", "Var4", "Var5", "Var6", "Var7"];
ts = timeseries(dt, [1;2;3], ["A";"B";"C"]);
for i = 1:5
    ts = addvars(ts, l(i), "After", "Var"+ string(i+1));
    assert_checkequal(ts, timeseries(dt, [1;2;3], ["A";"B"; "C"], l(1:i), "VariableNames", ["Time", "Var1" "Var2" str(1:i)]));
end

ts = timeseries(dt, [1 2;3 4; 5 6], "VariableNames", ["Time", "x1", "x2"]);
str = ["d", "s", "b", "dura", "dt"];
for i = 1:5
    ts = addvars(ts, l(i), "After", "x1", "NewVariableNames", str(i));
    assert_checkequal(ts, timeseries(dt, [1;3;5], l(i:-1:1), [2;4;6], "VariableNames", ["Time", "x1", str(i:-1:1) "x2"]));
end

t = table([1;2;3], ["A";"B";"C"]);

// Test case-sensitivity on options
assert_checktrue(execstr("addvars(t, var_double, ""newvariableNames"", ""Double"", ""aFTeR"", ""Var1"")", "errcatch") == 0); 
assert_checktrue(execstr("addvars(t, var_double, ""after"", ""Var1"", ""neWvariablenames"", ""Double"")", "errcatch") == 0); 
assert_checktrue(execstr("addvars(t, var_double, ""newvariableNames"", ""Double"", ""befoRE"", ""Var2"")", "errcatch") == 0); 
assert_checktrue(execstr("addvars(t, var_double, ""BeFoRe"", ""Var2"", ""neWvarIabLenames"", ""Double"")", "errcatch") == 0);