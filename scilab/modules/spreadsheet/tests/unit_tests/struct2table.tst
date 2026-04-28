// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for struct2table function
// =============================================================================

function checkstring(t, v)
    assert_checkequal(%table_string(t), v);
endfunction

clear s
s.city = ["Paris", "Lyon", "Marseille", "Bordeaux", "Toulouse"];
s.postal = [75000 69000 13000 33000 31000];
s.region = ["Ile-de-France", "Auvergne-Rhone-Alpes", "Provence-Alpes-Cote-Azur", "Nouvelle-Aquitaine", "Occitanie"];

t = struct2table(s);
checkstring(t, [s.city', string(s.postal)', s.region']);
assert_checkequal(size(t), [5 3]);
assert_checkequal(t.Properties.VariableNames, ["city", "postal", "region"]);

s.city = s.city';
s.postal = s.postal';
s.region = s.region';

t = struct2table(s);
checkstring(t, [s.city, string(s.postal), s.region]);
assert_checkequal(size(t), [5 3]);
assert_checkequal(t.Properties.VariableNames, ["city", "postal", "region"]);

clear s
s.id = [1;2;3];
s.scores = [90 85 88; 76 80 79; 89 91 94];

t = struct2table(s, "AsArray", %t);

assert_checkequal(t.id, {s.id});
assert_checkequal(t.scores, {s.scores});
assert_checkequal(t.Properties.VariableNames, ["id", "scores"]);

clear s
s.a = 1;
s.b = [10 20];
s(2) = struct("a", [1 2 3], "b", 10);
t = struct2table(s);
assert_checkequal(typeof(t.a), "ce");
assert_checkequal(typeof(t.b), "ce");
assert_checkequal(size(t), [2 2]);
assert_checkequal(t.Properties.VariableNames, ["a", "b"]);

t = struct2table(s, "AsArray", %t);
assert_checkequal(typeof(t.a), "ce");
assert_checkequal(typeof(t.b), "ce");
assert_checkequal(size(t), [2 2]);
assert_checkequal(t.Properties.VariableNames, ["a", "b"]);

clear s
s = struct("c", [1,2,3], "d", [2,3]');
t = struct2table(s, "AsArray", %t);

assert_checkequal(typeof(t.c), "ce");
assert_checkequal(typeof(t.d), "ce");
assert_checkequal(size(t), [1 2]);
assert_checkequal(t.Properties.VariableNames, ["c", "d"]);

s(2) = struct("c", [1,2,3]', "d", [2,3]');
t = struct2table(s);
assert_checkequal(typeof(t.c), "ce");
assert_checkequal(typeof(t.d), "ce");
assert_checkequal(size(t), [2 2]);
assert_checkequal(t.Properties.VariableNames, ["c", "d"]);

t = struct2table(s, "AsArray", %t);
assert_checkequal(typeof(t.c), "ce");
assert_checkequal(typeof(t.d), "ce");
assert_checkequal(size(t), [2 2]);
assert_checkequal(t.Properties.VariableNames, ["c", "d"]);