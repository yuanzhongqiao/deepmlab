// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Adeline CARNIS
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for table function
// =============================================================================

function checkstring(t, v)
    assert_checkequal(%table_string(t), v);
endfunction

a = ones(100, 1);
b = string(a);
c = ~(floor(2 * rand(100, 1)));
T = table(a, b, c);
checkstring(T, [string(a) b string(c)]);
assert_checkequal(size(T), [100, 3]);
assert_checkequal(T.Properties.Description, "");
assert_checkequal(T.Properties.VariableNames, ["Var1" "Var2" "Var3"]);
assert_checkequal(T.Properties.VariableDescriptions, ["" "" ""]);
assert_checkequal(T.Properties.RowNames, []);
assert_checkequal(T.Var1, a);
assert_checkequal(T.Var2, b);
assert_checkequal(T.Var3, c);
assert_checkequal(T("Var1"), a);
assert_checkequal(T("Var2"), b);
assert_checkequal(T("Var3"), c);
assert_checkequal(T(1, 1), table(1));
assert_checkequal(T(1, :), table(1, "1", c(1)));
assert_checkequal(T($, $), table(c($), "VariableNames", "Var3"));
assert_checkequal(T(:,$), table(c, "VariableNames", "Var3"));
assert_checkequal(T(1, "Var1"), table(1));
assert_checkequal(T(1, ["Var1", "Var2"]), table(1, "1"));
assert_checkequal(T(1, {"Var1", "Var2"}), table(1, "1"));
assert_checkequal(T(:, "Var1"), table(a));
assert_checkequal(T(:, ["Var1", "Var3"]), table(a, c, "VariableNames", ["Var1", "Var3"]));
assert_checkequal(T(:, {"Var1", "Var3"}), table(a, c, "VariableNames", ["Var1", "Var3"]));

// concatenation
TT = [T; T];
checkstring(TT, [string([a; a]), [b;b], string([c;c])]);
assert_checkequal(size(TT), [200, 3]);
assert_checkequal(TT.Properties.Description, "");
assert_checkequal(TT.Properties.VariableNames, ["Var1" "Var2" "Var3"]);
assert_checkequal(TT.Properties.VariableDescriptions, ["" "" ""]);
assert_checkequal(TT.Properties.RowNames, []);
assert_checkequal(TT.Var1, [a; a]);
assert_checkequal(TT.Var2, [b; b]);
assert_checkequal(TT.Var3, [c; c]);

T1 = table(a, b, c, "VariableNames", ["a", "b", "c"]);
TT = [T T1];
checkstring(TT, [string(a), b, string(c), string(a), b, string(c)]);
assert_checkequal(size(TT), [100, 6]);
assert_checkequal(TT.Properties.Description, "");
assert_checkequal(TT.Properties.VariableNames, ["Var1" "Var2" "Var3", "a", "b", "c"]);
assert_checkequal(TT.Properties.VariableDescriptions, ["" "" "" "" "" ""]);
assert_checkequal(TT.Properties.RowNames, []);
assert_checkequal(TT(["Var1", "a"]), [a a]);
assert_checkequal(TT(["Var2", "b"]), [b b]);
assert_checkequal(TT(["Var3", "c"]), [c c]);

// add RowNames
T.Row = "Row" + string(1:length(a))';
assert_checkequal(T.Properties.RowNames, "Row" + string(1:length(a))');
assert_checkequal(T("Row1", 1), table(a(1), "RowNames", "Row1"));
assert_checkequal(T("Row1", "Var1"), table(a(1), "RowNames", "Row1"));
assert_checkequal(T("Row1", :), table(a(1), b(1), c(1), "RowNames", "Row1"));
assert_checkequal(T("Row100", $), table(c($), "VariableNames", "Var3", "RowNames", "Row100"));
assert_checkequal(T("Row100", :), table(a($), b($), c($), "RowNames", "Row100"));
assert_checkequal(T(["Row1", "Row10"], [1 3]), table([a(1); a(10)], [c(1); c(10)], "VariableNames", ["Var1", "Var3"], "RowNames", ["Row1"; "Row10"]));

// change VariableNames
T.Properties.VariableNames = ["A", "B", "C"];
assert_checkequal(T.Properties.VariableNames, ["A", "B", "C"]);
assert_checkequal(T("Row1", "A"), table(a(1), "RowNames", "Row1", "VariableNames", "A"));
assert_checkequal(T(["Row1", "Row100"], ["A", "C"]), table([a(1); a(100)], [c(1); c(100)], "VariableNames", ["A", "C"], "RowNames", ["Row1"; "Row100"]));
res = T(:, "A")("Row1", 1);
assert_checkequal(res, table(a(1), "VariableNames", ["A"], "RowNames", ["Row1"]));
res = T(1:2, 1:2);
assert_checkequal(res, table(a(1:2), b(1:2), "RowNames", ["Row1"; "Row2"], "VariableNames", ["A", "B"]));

// Insertion
T.A = 2;
assert_checkequal(T, table(2*a, b, c, "VariableNames", ["A", "B", "C"], "RowNames", "Row"+string(1:length(a))'));

T.A(1) = 20;
assert_checkequal(T.A, [20; 2*ones(99,1)]);
assert_checkequal(T("A"), [20; 2*ones(99,1)]);
assert_checkequal(T(:, "A"), table([20; 2*ones(99,1)], "RowNames", "Row"+string(1:length(a))', "VariableNames", ["A"]));
assert_checkequal(T(:, 1), table([20; 2*ones(99,1)], "RowNames", "Row"+string(1:length(a))', "VariableNames", ["A"]));

T(1, "A") = 100;
assert_checkequal(T.A, [100; 2*ones(99,1)]);
assert_checkequal(T("A"), [100; 2*ones(99,1)]);
assert_checkequal(T(:, "A"), table([100; 2*ones(99,1)], "RowNames", "Row"+string(1:length(a))', "VariableNames", ["A"]));
assert_checkequal(T(:, 1), table([100; 2*ones(99,1)], "RowNames", "Row"+string(1:length(a))', "VariableNames", ["A"]));

T($, "A") = 100;
assert_checkequal(T.A, [100; 2*ones(98,1); 100]);
assert_checkequal(T("A"), [100; 2*ones(98,1); 100]);
assert_checkequal(T(:, "A"), table([100; 2*ones(98,1); 100], "RowNames", "Row"+string(1:length(a))', "VariableNames", ["A"]));
assert_checkequal(T(:, 1), table([100; 2*ones(98,1); 100], "RowNames", "Row"+string(1:length(a))', "VariableNames", ["A"]));

T(:, "A") = 50;
assert_checkequal(T.A, 50*ones(100,1));
assert_checkequal(T("A"), 50*ones(100,1));
assert_checkequal(T(:, "A"), table(50*ones(100,1), "RowNames", "Row"+string(1:length(a))', "VariableNames", ["A"]));
assert_checkequal(T(:, 1), table(50*ones(100,1), "RowNames", "Row"+string(1:length(a))', "VariableNames", ["A"]));

T(1, 2) = "2";
aa = 50*ones(100,1);
bb = b; bb(1) = "2";
assert_checkequal(T, table(aa, bb, c, "VariableNames", ["A", "B", "C"], "RowNames", "Row"+string(1:length(a))'));

T = table([1;2], [3;4], "RowNames", ["R1"; "R2"], "VariableNames", ["toto", "titi"]);
T($, 1) = 1;
assert_checkequal(T, table([1;1], [3;4], "RowNames", ["R1"; "R2"], "VariableNames", ["toto", "titi"]));
T("R1", 1) = 2;
T("R1", "titi") = 10;
T("R2", :) = 0;
assert_checkequal(T, table([2;0], [10;0], "RowNames", ["R1"; "R2"], "VariableNames", ["toto", "titi"]));
T(1:2,1:2) = 3;
assert_checkequal(T, table([3;3], [3;3], "RowNames", ["R1"; "R2"], "VariableNames", ["toto", "titi"]));
T(1:2,1:2) = [1 2;3 4];
assert_checkequal(T, table([1;3], [2;4], "RowNames", ["R1"; "R2"], "VariableNames", ["toto", "titi"]));
T(["R1", "R2"], ["toto", "titi"]) = 0;
assert_checkequal(T, table([0;0], [0;0], "RowNames", ["R1"; "R2"], "VariableNames", ["toto", "titi"]));

T = table([1;2;3], [4;5;6], [7;8;9], "RowNames", ["R1"; "R2";"R3"], "VariableNames", ["a", "b", "c"]);
T({'R1','R3'}, $) = {1;3};
assert_checkequal(T, table([1;2;3], [4;5;6], [1;8;3], "RowNames", ["R1"; "R2";"R3"], "VariableNames", ["a", "b", "c"]));
T({'R1','R3'}, $) = table([2;4]);
assert_checkequal(T, table([1;2;3], [4;5;6], [2;8;4], "RowNames", ["R1"; "R2";"R3"], "VariableNames", ["a", "b", "c"]));
T($, {"a", "b"}) = table(10,20);
assert_checkequal(T, table([1;2;10], [4;5;20], [2;8;4], "RowNames", ["R1"; "R2";"R3"], "VariableNames", ["a", "b", "c"]));
T($, {"a", "b"}) = {1, 2};
assert_checkequal(T, table([1;2;1], [4;5;2], [2;8;4], "RowNames", ["R1"; "R2";"R3"], "VariableNames", ["a", "b", "c"]));

// remove row or col
T.a = [];
assert_checkequal(T, table([4;5;2], [2;8;4], "RowNames", ["R1"; "R2";"R3"], "VariableNames", ["b", "c"]));
T("R2", :) = [];
assert_checkequal(T, table([4;2], [2;4], "RowNames", ["R1"; "R3"], "VariableNames", ["b", "c"]));

T = table([1;2;3], [4;5;6], [7;8;9], "RowNames", ["R1"; "R2";"R3"], "VariableNames", ["a", "b", "c"]);
T(:, $+1:$+2) = 5;
assert_checkequal(T, table([1;2;3], [4;5;6], [7;8;9], [5;5;5], [5;5;5],"RowNames", ["R1"; "R2";"R3"], "VariableNames", ["a", "b", "c", "Var4", "Var5"]));

// $+1:$+2
A = table(ones(5,1), 2*ones(5,1));
A(:, $+1:$+2) = [3 4] .*. ones(5, 1);
assert_checkequal(A, table(ones(5,1), 2*ones(5,1), 3*ones(5,1), 4*ones(5,1)));
A(:, $+1:$+2) = num2cell([5 6] .*. ones(5, 1));
assert_checkequal(A, table([1 2 3 4 5 6] .*. ones(5, 1)));
A(:, $+1:$+3) = table([7 8 9].*.ones(5,1));
assert_checkequal(A, table([1 2 3 4 5 6 7 8 9] .*. ones(5, 1)));

A = table(ones(5,1), 2*ones(5,1));
A(:, $+1:5) = [3 4 5] .*. ones(5,1);
assert_checkequal(A, table([1 2 3 4 5] .*. ones(5, 1)));
A(:, 6:$+4) = [6 7 8 9] .*. ones(5,1);
assert_checkequal(A, table([1 2 3 4 5 6 7 8 9] .*. ones(5, 1)));

A = table(ones(5,1), 2*ones(5,1));
A(:, $+1:5) = 5;
assert_checkequal(A, table([1 2 5 5 5] .*. ones(5, 1)));

A = table(ones(5,1), 2*ones(5,1));
A(:, $+1:5) = num2cell([3 4 5] .*. ones(5,1));
assert_checkequal(A, table([1 2 3 4 5] .*. ones(5, 1)));
A(:, 6:$+4) = num2cell([6 7 8 9] .*. ones(5,1));
assert_checkequal(A, table([1 2 3 4 5 6 7 8 9] .*. ones(5, 1)));

A = table(ones(5,1), 2*ones(5,1));
A(:, $+1:5) = table([3 4 5] .*. ones(5,1));
assert_checkequal(A, table([1 2 3 4 5] .*. ones(5, 1)));
A(:, 6:$+4) = table([6 7 8 9] .*. ones(5,1));
assert_checkequal(A, table([1 2 3 4 5 6 7 8 9] .*. ones(5, 1)));

// table(mat)
T = table([1 2; 3 4]);
checkstring(T, string([1 2;3 4]));
assert_checkequal(T, table([1;3], [2;4]));
T = table([1 2; 3 4], "VariableNames", ["c1", "c2"], "RowNames", ["r1", "r2"]);
assert_checkequal(T.Properties.VariableNames, ["c1", "c2"]);
assert_checkequal(T.Row, ["r1"; "r2"]);

T = table([1;2;1], [3 4;5 6;0 1], [7; 8; 9]);
checkstring(T, string([1 3 4 7;2 5 6 8; 1 0 1 9]));
assert_checkequal(T, table([1;2;1], [3;5;0], [4;6;1], [7;8;9]));
T = table([1;2;1], [3 4;5 6;0 1], [7; 8; 9], "RowNames", ["r1", "r2", "r3"], "VariableNames", ["c1", "c2", "c3", "c4"]);
assert_checkequal(T.Properties.VariableNames, ["c1", "c2", "c3", "c4"]);
assert_checkequal(T.Row, ["r1"; "r2"; "r3"]);

A = [1 2 3; 4 5 6; 7 8 9];
T = matrix2table(A);
assert_checkequal(T, table(A(:,1), A(:,2), A(:,3)));
assert_checkequal(size(T), [3 3]);
T = matrix2table(A, "VariableNames", ["a", "b", "c"], "RowNames", ["r1"; "r2"; "r3"]);
assert_checkequal(T, table(A(:,1), A(:,2), A(:,3), "VariableNames", ["a", "b", "c"], "RowNames", ["r1"; "r2"; "r3"]));
assert_checkequal(T.Properties.VariableNames, ["a", "b", "c"]);
assert_checkequal(T.Properties.RowNames, ["r1"; "r2"; "r3"]);

// table(st)
S.Name = ["Anne"; "Hugo"; "Charles"];
S.Age = [12; 15; 10];
S.Sport = ["Hand"; "Rugby"; "Foot"];
T = table(S);
checkstring(T, [S.Name, string(S.Age), S.Sport]);
assert_checkequal(size(T), [3 3]);
assert_checkequal(T.Properties.VariableNames, ["Name", "Age", "Sport"]);
assert_checkequal(T.Properties.RowNames, []);
T.Properties.RowNames = T.Name;
T.Name = [];
assert_checkequal(T.Properties.VariableNames, ["Age", "Sport"]);
assert_checkequal(T.Properties.RowNames, S.Name);

T = struct2table(S);
checkstring(T, [S.Name, string(S.Age), S.Sport]);
assert_checkequal(size(T), [3 3]);
assert_checkequal(T.Properties.VariableNames, ["Name", "Age", "Sport"]);

// table2matrix(T)
T = table([1;2;3],[2 8; 4 10; 6 12],[3 12 21; 6 15 24; 9 18 27],'VariableNames',["One" "Two_1" "Two_2", "Three_1" "Three_2" "Three_3"]);
mat = table2matrix(T);
assert_checkequal(mat, [1 2 8 3 12 21;2 4 10 6 15 24; 3 6 12 9 18 27]);

T = table(["a";"b";"c";"d";"e"], [10;20;30;40;50], [1;2;3;4;5], [%t;%f;%t;%f;%t]);
mat = table2matrix(T(:,2:3));
assert_checkequal(mat, [10 1;20 2; 30 3; 40 4; 50 5]);

// table2struct(T)
S.Name = ["Anne"; "Hugo"; "Charles"];
S.Age = [12; 15; 10];
S.Sport = ["Hand"; "Rugby"; "Foot"];
T = table(S);
assert_checkequal(table2struct(T, "ToScalar", %t), S);
expected = [];
for i = 1:3
    for g = fieldnames(S)'
        tmp(g) = S(g)(i);
    end
    expected = [expected; tmp];
end
assert_checkequal(table2struct(T), expected);

// cell2table
c = cell2table({1,[1;2]});
assert_checkequal(c, table(1, {[1;2]}));

// timeseries2table
refMsg = msprintf(_("%s: Wrong type for input argument #%d: A timeseries expected.\n"), "timeseries2table", 1);
assert_checkerror("timeseries2table(T)", refMsg);
Time = datetime(2023, 6, 1:3)';
A = [1; 2; 3];
B = [10; 20; 30];
C = [-10;-20;-30];
ts = timeseries(Time,A,B,C);
T = timeseries2table(ts);
assert_checkequal(T, table(Time, A, B, C, "VariableNames", ["Time", "Var1", "Var2", "Var3"]));
ts.Properties.VariableNames = ["Time", "A", "B", "C"];
T = timeseries2table(ts);
assert_checkequal(T, table(Time, A, B, C, "VariableNames", ["Time", "A", "B", "C"]));
assert_checkequal(T.Row, []);
T = timeseries2table(ts, "RowNames", ["l1", "l2", "l3"]);
assert_checkequal(T.Row, ["l1", "l2", "l3"]');
T(:, [2:3]) = [];
assert_checkequal(T, table(Time, C, "VariableNames", ["Time", "C"], "RowNames", ["l1", "l2", "l3"]));

refMsg = msprintf(_("%s: Wrong type for input argument #%d: A table expected.\n"), "table2timeseries", 1);
assert_checkerror("table2timeseries(ts)", refMsg);

// complex data
T = table(1+%i, 2, %t, "toto");
assert_checkequal(string(T), ["1+%i" "2" "T" "toto"]);

T = table([1;2], [3;%i], [2*%i; 4]);
assert_checkequal(string(T), ["1" "3" "%i*2"; "2" "%i" "4"]);

msg = msprintf(_("%s: Wrong number of input argument: At least %d expected.\n"), "table", 1);
assert_checkerror("table()", msg);

t = table(["A"; "B"; "C"], [1; 2; 3], "VariableNames", ["Key", "Value"]);
assert_checkequal(t(t.Key == "A"), table("A", 1, "VariableNames", ["Key", "Value"]));

// insertion in table
t = table([], [], "VariableNames", ["A", "B"]);
t("a", :) = [0, 1];
assert_checkequal(t, table(0, 1, "VariableNames", ["A", "B"], "RowNames", "a"));

t("b", :) = [1, 2];
assert_checkequal(t, table([0 1; 1 2], "VariableNames", ["A", "B"], "RowNames", ["a"; "b"]));

t("c", :) = [2, 3];
assert_checkequal(t, table([0 1; 1 2; 2 3], "VariableNames", ["A", "B"], "RowNames", ["a"; "b"; "c"]));

t("", :) = [3, 4];
assert_checkequal(t, table([0 1; 1 2; 2 3; 3 4], "VariableNames", ["A", "B"], "RowNames", ["a"; "b"; "c"; ""]));
t.Row($) = "d";
assert_checkequal(t.Row, ["a"; "b"; "c"; "d"]);

// table with integers
inttyp = ["int8", "int16", "int32", "int64", "uint8", "uint16", "uint32", "uint64"];
mat = [1 2;3 4];
for i = inttyp
    execstr("m = " + i + "(mat)");
    t = table(m);
    assert_checkequal(typeof(t("Var1")), i);
    assert_checkequal(typeof(t.Var2), i);

    execstr("b = t(""Var1"") == " + i + "([1; 3])");
    assert_checktrue(b);
    execstr("b = t.Var2 == " + i + "([2; 4])");
    assert_checktrue(b);
end

// Test case-sensitivity on options
assert_checktrue(execstr("table([1;2;3], [4;5;6], [7;8;9], ""rowNames"", [""R1"";""R2"";""R3""], ""variableNames"", [""a"", ""b"", ""c""])", "errcatch") == 0);
assert_checktrue(execstr("table([1;2], [4;5], ""variablenames"", [""a1"", ""a2""], ""roWnameS"", [""b1"";""b2""])", "errcatch") == 0);

// RowNames 
a = ["A" "B" "C" "0101"; "" "" "" ""];
t = matrix2table(a, "RowNames", ["values" "non-values"]);
assert_checkequal(t.Row, ["values"; "non-values"]);
t = matrix2table(a, "RowNames", ["values" "non-values"]');
assert_checkequal(t.Row, ["values"; "non-values"]);

msg = msprintf(_("%s: Wrong size for ""%s"" argument: Must be a vector containing %d elements.\n"), "table", "RowNames", 2);
assert_checkerror("matrix2table(a, ""RowNames"", ""values"")", msg);
