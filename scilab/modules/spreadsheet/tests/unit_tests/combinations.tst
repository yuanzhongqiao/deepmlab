// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

fname = "combinations";
msg = msprintf(_("%s: Wrong number of input argument: At least %d expected.\n"), fname, 1);
assert_checkerror("combinations()", msg);

typ = ["constant", "boolean", "string", "datetime", "duration"];
msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), fname, 1, sci2exp(typ));
assert_checkerror("combinations(int8([1;2;3]), [3;4])", msg);
msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), fname, 2, sci2exp(typ));
assert_checkerror("combinations([1;2;3], uint32([3;4]))", msg);

a = [1 2 3];
b = ["a"; "b"];
c = combinations(a, b);
assert_checkequal(size(c), [6 2]);
expected = table([1;1;2;2;3;3], [b;b;b]);
assert_checkequal(c, expected);

c = combinations(a', b');
assert_checkequal(size(c), [6 2]);
assert_checkequal(c, expected);

a = [1 2; 3 4];
c = combinations(a, b);
assert_checkequal(size(c), [8 2]);
expected = table([1;1;3;3;2;2;4;4], [b;b;b;b]);
assert_checkequal(c, expected);

a = [1 4 7];
b = ["red"; "green"; "blue"];
f = [%f %t];
c = combinations(a, b, f);
assert_checkequal(size(c), [18 3]);
expected = table([ones(6, 1); 4 * ones(6,1); 7 * ones(6,1)], repmat(["red"; "green"; "blue"], 3,2)'(:), repmat(f', 9, 1));
assert_checkequal(c, expected);

d = datetime(2025,[4;5;6],1);
dura = hours(1:3)';
c = combinations(d, dura);
assert_checkequal(size(c), [9 2]);
expected = table(datetime(2025, [4;4;4;5;5;5;6;6;6], 1), [dura; dura; dura]);
assert_checkequal(c, expected);