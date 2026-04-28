// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for removevars function

// with table
t = table(["A"; "B"; "B"; "A"], [1;2;3;4], [%t; %f; %t; %f], hours(1:4)', datetime(2024,1,[1;2;3;4]), "VariableNames", "x"+ string(1:5));

t2 = removevars(t, "x1");
assert_checkequal(t2.Properties.VariableNames, "x" + string(2:5));
assert_checkequal(t2, t(:, 2:$));

t2 = removevars(t, [3 5]);
assert_checkequal(t2.Properties.VariableNames, ["x1", "x2", "x4"]);
assert_checkequal(t2, t(:, [1 2 4]));

t2 = removevars(t, ["x2", "x4", "x5"]);
assert_checkequal(t2.Properties.VariableNames, ["x1", "x3"]);
assert_checkequal(t2, t(:, [1 3]));

t2 = removevars(t, {"x1", "x5"});
assert_checkequal(t2.Properties.VariableNames, ["x2", "x3", "x4"]);
assert_checkequal(t2, t(:, 2:4));

t2 = removevars(t, [%t %f %t %f %t]);
assert_checkequal(t2.Properties.VariableNames, ["x2", "x4"]);
assert_checkequal(t2, t(:, [2 4]));

// with timeseries
ts = table2timeseries(t, "RowTimes", "x5");

t2 = removevars(ts, "x1");
assert_checkequal(t2.Properties.VariableNames, ["x5", "x2", "x3", "x4"]);
assert_checkequal(t2, ts(:, 2:$));

t2 = removevars(ts, [3 4]);
assert_checkequal(t2.Properties.VariableNames, ["x5", "x1", "x2"]);
assert_checkequal(t2, ts(:, [1 2]));

t2 = removevars(ts, ["x2", "x4", "x1"]);
assert_checkequal(t2.Properties.VariableNames, ["x5", "x3"]);
assert_checkequal(t2, ts(:, 3));

t2 = removevars(ts, {"x1", "x4"});
assert_checkequal(t2.Properties.VariableNames, ["x5", "x2", "x3"]);
assert_checkequal(t2, ts(:, 2:3));

t2 = removevars(ts, [%t %f %t %f]);
assert_checkequal(t2.Properties.VariableNames, ["x5", "x2", "x4"]);
assert_checkequal(t2, ts(:, [2 4]));

// check errors
msg = msprintf(_("%s: Wrong number of input argument(s): %d expected.\n"), "removevars", 2);
assert_checkerror("removevars()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "removevars", 1, sci2exp(["table", "timeseries"]));
assert_checkerror("removevars(1, 1)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "removevars", 2, sci2exp(["double","boolean","string","cell"]));
assert_checkerror("removevars(t, t)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be a vector.\n"), "removevars", 2);
assert_checkerror("removevars(t, [1 2; 3 4])", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: A valid variable name expected.\n"), "removevars", 2);
assert_checkerror("removevars(t, ""x6"")", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: A valid column index expected.\n"), "removevars", 2);
assert_checkerror("removevars(t, 6)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: A valid variable name expected.\n"), "removevars", 2);
assert_checkerror("removevars(t, {""x6""})", msg);