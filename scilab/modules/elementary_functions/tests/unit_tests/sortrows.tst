// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for sortrows function
// =============================================================================

A = [3 7 2; 1 9 4; 2 5 6];
[B, idx] = sortrows(A, 1);
expected = [1 9 4; 2 5 6; 3 7 2];
assert_checkequal(B, expected);
assert_checkequal(idx, [2; 3; 1]);

[B, idx] = sortrows(A, 1, "i");
assert_checkequal(B, expected);
assert_checkequal(idx, [2; 3; 1]);

[B, idx] = sortrows(A, 2, "d");
expected = [1 9 4; 3 7 2; 2 5 6];
assert_checkequal(B, expected);
assert_checkequal(idx, [2; 1; 3]);

A = [3 7 2; 3 5 4; 1 5 6; 3 5 1];
[B, idx] = sortrows(A, [1 2]);
expected = [1 5 6; 3 5 4; 3 5 1; 3 7 2];
assert_checkequal(B, expected);
assert_checkequal(idx, [3; 2; 4; 1]);

[B, idx] = sortrows(A, [1 2], ["i", "i"]);
assert_checkequal(B, expected);
assert_checkequal(idx, [3; 2; 4; 1]);

A = [3 7 2; 3 5 4; 3 5 6; 3 5 1];
[B, idx] = sortrows(A, [2 3], ["i", "d"]);
expected = [3 5 6; 3 5 4; 3 5 1; 3 7 2];
assert_checkequal(B, expected);
assert_checkequal(idx, [3; 2; 4; 1]);

[B, idx] = sortrows(A, [2 3], {"i", "d"});
assert_checkequal(B, expected);
assert_checkequal(idx, [3; 2; 4; 1]);

[B, idx] = sortrows(A, [2 3], ["ascend", "descend"]);
assert_checkequal(B, expected);
assert_checkequal(idx, [3; 2; 4; 1]);

[B, idx] = sortrows(A, [2 3], {"ascend", "descend"});
assert_checkequal(B, expected);
assert_checkequal(idx, [3; 2; 4; 1]);

A = ["b" "y"; "a" "r"; "c" "r"];
[B, idx] = sortrows(A, 2, "d");
assert_checkequal(B, A);
assert_checkequal(idx, [1;2;3]);

A = ["o" "m"; "a" "s"; "a" "l"; "b" "s"];
[B, idx] = sortrows(A, [1 2], ["i", "i"]);
expected = ["a" "l"; "a" "s"; "b" "s"; "o" "m"];
assert_checkequal(B, expected);
assert_checkequal(idx, [3; 2; 4; 1]);

[B, idx] = sortrows(A, [1 2], {"i", "i"});
assert_checkequal(B, expected);
assert_checkequal(idx, [3; 2; 4; 1]);

[B, idx] = sortrows(A, [1 2], ["ascend", "ascend"]);
assert_checkequal(B, expected);
assert_checkequal(idx, [3; 2; 4; 1]);

[B, idx] = sortrows(A, [1 2], {"ascend", "ascend"});
assert_checkequal(B, expected);
assert_checkequal(idx, [3; 2; 4; 1]);

A = [3 2 1;2 3 1; 1 3 2; 3 1 2];
t = matrix2table(A);
[newt, index] = sortrows(t);
expected = matrix2table([1 3 2;2 3 1; 3 1 2; 3 2 1]);
assert_checkequal(newt, expected);
assert_checkequal(index, [3; 2; 4; 1]);


t = table(["a"; "b"; "c"; "b"], [1; 2; 1; 1], [1; 2; 3; 4]);
[newt, index] = sortrows(t);
expected = table(["a"; "b"; "b"; "c"], [1; 1; 2; 1], [1; 4; 2; 3]);
assert_checkequal(newt, expected);
assert_checkequal(index, [1; 4; 2; 3]);

A = table(["Oak"; "Pine"; "Maple"; "Apple"; "Pear"], [15; 30; 25; 3; 2], ["Tree"; "Tree"; "Tree"; "FruitTree"; "FruitTree"], ...
'VariableNames', ["Name","Height","Type"]);

[B, idx] = sortrows(A, 2);
assert_checkequal(B, A(idx, :));

[C, idxC] = sortrows(A, "Height", "d");
assert_checkequal(C, A(idxC, :));

[D, idxD] = sortrows(A, [%f %t %f], "i");
assert_checkequal(D, A(idxD, :));

Planet = ["Mercury"; "Venus"; "Earth"; "Mars"; "Jupiter"; ...
"Saturn"; "Uranus"; "Neptune"; "Pluto"];

// Type (Pluto included as "Dwarf")
Category = ["Terrestrial"; "Terrestrial"; "Terrestrial"; "Terrestrial"; ...
"GasGiant"; "GasGiant"; "IceGiant"; "IceGiant"; "Dwarf"];

// Distance from the Sun in millions of km
Distance_Mkm = [57.9; 108.2; 149.6; 227.9; 778.5; 1434; 2871; 4495; 5906];

// Equatorial diameter in km
Diameter_km = [4879; 12104; 12742; 6779; 139820; 116460; 50724; 49244; 2376];

// Number of known sattelites
Moons = [0; 0; 1; 2; 79; 82; 27; 14; 5];

T = table(Category, Distance_Mkm, Diameter_km, Moons, ...
'RowNames', Planet, "VariableNames", ....
["Category", "Distance_Mkm", "Diameter_km", "Moons"]);

// Sort by distance from the Sun (ascend)
[T1, idx] = sortrows(T, 'Distance_Mkm');
assert_checkequal(T1, T(idx, :));

// Sort by decreasing diameter
[T2, idx] = sortrows(T, 'Diameter_km', 'd');
assert_checkequal(T2, T(idx, :));

[T3, idx] = sortrows(T, ['Category','Moons'], ['i','d']);
assert_checkequal(T3, T(idx, :));

[T3, idx] = sortrows(T, ['Category','Moons'], {'i','d'});
assert_checkequal(T3, T(idx, :));

[T3, idx] = sortrows(T, {'Category','Moons'}, ['i','d']);
assert_checkequal(T3, T(idx, :));

[T3, idx] = sortrows(T, {'Category','Moons'}, {'i','d'});
assert_checkequal(T3, T(idx, :));

ts = timeseries(hours([10; 5; 8; 12]), (1:4)');
[tss, idx] = sortrows(ts, 1);
assert_checkequal(string(tss), string(ts(idx, :)));

[tss, idx] = sortrows(ts, "Time");
assert_checkequal(string(tss), string(ts(idx, :)));

[tss, idx] = sortrows(ts, 1, "i");
assert_checkequal(string(tss), string(ts(idx, :)));

[tss, idx] = sortrows(ts, "Time", "i");
assert_checkequal(string(tss), string(ts(idx, :)));

ts2 = timeseries(datetime(2025, 9, 1) + seconds([100; 200; 150]), [3; 1; 2]);
[tss, idx] = sortrows(ts2, 2, "d");
assert_checkequal(string(tss), string(ts2(idx, :)));

[tss, idx] = sortrows(ts2, "Var1", "d");
assert_checkequal(string(tss), string(ts2(idx, :)));