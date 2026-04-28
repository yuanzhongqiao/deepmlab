// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for join function
// =============================================================================

tleft = table([1; 2; 2; 3; 4; 4; 5], ["a"; "b"; "c"; "d"; "e"; "f"; "g"], "VariableNames", ["k1", "v1"]);
tright = table([5; 3; 1; 2; 4], ["aa"; "bb"; "cc"; "dd"; "ee"], "VariableNames", ["k1", "v2"]);

t = join(tleft, tright);
expected = [tleft table(["cc"; "dd"; "dd"; "bb"; "ee"; "ee"; "aa"], "VariableNames", "v2")];
assert_checkequal(t, expected);

tright = table([5; 3; 6; 1; 2; 4], ["aa"; "bb"; "cc"; "dd"; "ee"; "ff"], "VariableNames", ["k1", "v2"]);
t = join(tleft, tright);
expected = [tleft, table(["dd"; "ee"; "ee"; "bb"; "ff"; "ff"; "aa"], "VariableNames", "v2")];
assert_checkequal(t, expected);

tleft = table(["Anna"; "Rob"; "Hugo"; "Kate"; "Mary"], ["F"; "M"; "M"; "F"; "F"], "VariableNames", ["FirstName", "Gender"]);
tright = table(["F"; "M"], ["Tennis"; "Rugby"], "VariableNames", ["Gender", "Sport"]);
t = join(tleft, tright);
expected = [tleft, table(["Tennis"; "Rugby"; "Rugby"; "Tennis"; "Tennis"], "VariableNames", "Sport")];
assert_checkequal(t, expected);

a = cell2table({1, "a"; 2, "b"; 3, "c"}, "VariableNames", ["a", "b"]);
c = cell2table({3, "c", 10; 1, "a", 12; 2 ,"b", 14; 3, "d", 0}, "VariableNames", ["a", "b", "c"]);
t = join(a, c);
expected = cell2table({1, "a", 12; 2, "b", 14; 3, "c", 10}, "VariableNames", ["a", "b", "c"]);
assert_checkequal(t, expected);

t = join(a, c, "Keys", "b");
expected = cell2table({1, "a", 1, 12; 2, "b", 2, 14; 3, "c", 3, 10}, "VariableNames", ["a_Tleft", "b", "a_Tright", "c"]);
assert_checkequal(t, expected);
t = join(a, c, "Keys", 2);
assert_checkequal(t, expected);

t = join(a, c, "Keys", "b", "KeepOneCopy", "a");
expected = cell2table({1, "a", 12; 2, "b", 14; 3, "c", 10}, "VariableNames", ["a", "b", "c"]);
assert_checkequal(t, expected);
t = join(a, c, "Keys", 2, "KeepOneCopy", "a");
assert_checkequal(t, expected);

b = cell2table({3, "c", 10; 1, "a", 12; 2 ,"b", 14; 4, "d", 0}, "VariableNames", ["a", "d", "c"]);
t = join(a, b);
expected = cell2table({1, "a", "a", 12; 2, "b", "b", 14; 3, "c", "c", 10}, "VariableNames", ["a", "b", "d", "c"]);
assert_checkequal(t, expected);

t = join(a, b, "LeftKeys", "b", "RightKeys", "d");
expected = cell2table({1, "a", 1, 12; 2, "b", 2, 14; 3, "c", 3, 10}, "VariableNames", ["a_Tleft", "b", "a_Tright", "c"]);
assert_checkequal(t, expected);

t = join(a, b, "LeftKeys", 2, "RightKeys", 2);
assert_checkequal(t, expected);

t = join(a, b, "LeftKeys", "b", "RightKeys", "d", "KeepOneCopy", "a");
expected = cell2table({1, "a", 12; 2, "b", 14; 3, "c", 10}, "VariableNames", ["a", "b", "c"]);
assert_checkequal(t, expected);

t = join(a, b, "LeftKeys", 2, "RightKeys", 2, "KeepOneCopy", "a");
assert_checkequal(t, expected);

// Test case-sensitivity on options
assert_checktrue(execstr("join(a, c, ""keys"", ""b"", ""keeponecopy"", ""a"")", "errcatch") == 0);
assert_checktrue(execstr("join(a, c, ""KeYs"", ""b"", ""KeepoNEcopy"", ""a"")", "errcatch") == 0);
assert_checktrue(execstr("join(a, b, ""leFTkeyS"", ""b"", ""rIghtkEYs"", ""d"")", "errcatch") == 0);


a = timeseries(hours(1:3)', ["a", "b", "c"]', "VariableNames", ["hours", "b"]);
c = timeseries(hours([3;1;2;3]), ["c"; "a"; "b";"d"], [10; 12; 14; 0], "VariableNames", ["hours", "b", "c"]);
t = join(a, c);
expected = timeseries(hours(1:3)', ["a"; "b"; "c"], [12; 14; 10], "VariableNames", ["hours", "b", "c"]);
assert_checkequal(t, expected);

t = join(a, c, "Keys", ["hours", "b"]);
assert_checkequal(t, expected);

t = join(a, c, "Keys", "b");
assert_checkequal(t, expected);
t = join(a, c, "Keys", 2);
assert_checkequal(t, expected);

t = join(a, c, "Keys", ["hours", "b"], "RightVariables", "b");
expected = timeseries(hours(1:3)', ["a"; "b"; "c"], ["a"; "b"; "c"], "VariableNames", ["hours", "b_Tleft", "b_Tright"]);
assert_checkequal(t, expected);

b = timeseries(hours([3;1;2;4]), ["c"; "a"; "b";"d"], [10; 12; 14; 0], "VariableNames", ["hours", "d", "c"]);
t = join(a, b);
expected = timeseries(hours(1:3)', ["a"; "b"; "c"], ["a"; "b"; "c"], [12; 14; 10], "VariableNames", ["hours", "b", "d", "c"]);
assert_checkequal(t, expected);

t = join(a, b, "LeftKeys", "hours", "RightKeys", "hours");
assert_checkequal(t, expected);

t = join(a, b, "LeftKeys", "b", "RightKeys", "d");
expected = timeseries(hours(1:3)', ["a"; "b"; "c"], [12; 14; 10], "VariableNames", ["hours", "b", "c"]);;
assert_checkequal(t, expected);

t = join(a, b, "LeftKeys", 2, "RightKeys", 2);
assert_checkequal(t, expected);

a = timeseries(hours(1:3)', ["a", "b", "c"]', "VariableNames", ["hours", "b"]);
c = cell2table({3, "c", 10; 1, "a", 12; 2 ,"b", 14; 3, "d", 0}, "VariableNames", ["a", "b", "c"]);
t = join(a, c);
expected = timeseries(hours(1:3)', ["a";"b";"c"], [1;2;3], [12;14;10], "VariableNames", ["hours", "b", "a", "c"]);

assert_checkequal(t, expected);
b = cell2table({3, "c", 10; 1, "a", 12; 2 ,"b", 14; 4, "d", 0}, "VariableNames", ["a", "d", "c"]);
t = join(a, b, "LeftKeys", "b", "RightKeys", "d");
expected = timeseries(hours(1:3)', ["a"; "b"; "c"], [1;2;3], [12;14;10], "VariableNames", ["hours", "b", "a", "c"]);

// check errors
msg = msprintf(_("%s: Wrong number of input argument(s): at least %d expected.\n"), "join", 2);
assert_checkerror("join()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "join", 1, sci2exp(["table", "timeseries"]));
assert_checkerror("join([1 2], 1)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "join", 2, sci2exp(["table", "timeseries"]));
assert_checkerror("join(a, [1 2])", msg);

msg = msprintf(_("%s: ""%s"" and ""%s"" must be used together.\n"), "join", "LeftKeys", "RightKeys");
assert_checkerror("join(a, b, ""LeftKeys"", ""hours"")", msg);

msg = msprintf(_("%s: Impossible to use the ""%s"" with ""%s"" and ""%s"".\n"), "join", "Keys", "LeftKeys", "RightKeys");
assert_checkerror("join(a, b, ""Keys"", ""hours"", ""LeftKeys"", ""hours"")", msg);