// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for polyval function
// =============================================================================

assert_checkequal(polyval(1, 1), 1);

// poly: 1 + x^2 - 2x^3
x = -2:2;
p = [-2 1 0 1];
y = polyval(p, x);
expected = [21 4 1 0 -11];
assert_checkequal(y, expected);

p = poly([1 0 1 -2], "x", "coeff");
y = polyval(p, x);
assert_checkequal(y, expected);

// poly: 2x^5-x^3+5x-1
p = [2 0 -1 0 5 -1];
y = polyval(p, x);
expected = [-67 -7 -1 5 65];
assert_checkequal(y, expected);

p = poly(p($:-1:1), "x", "coeff");
y = polyval(p, x);
assert_checkequal(y, expected);

x = 0:5;
f = #(x) -> (2*x.^3 - 12*x + 2);
yexp = f(x);
y = polyval([2 0 -12 2], x);
assert_checkequal(y, yexp);

x = -2:2;
y = [13 8 5 4 5];
[p, S, mu] = polyfit(x, y, 2);
res = polyval(p, x, [], mu);
assert_checkalmostequal(res, y, [], 1e-15);

// checkerror
msg = msprintf(_("%s: Wrong number of input arguments: At least %d expected.\n"), "polyval", 3);
assert_checkerror("[y, d] = polyval(p, x, [], mu)", msg);

msg = msprintf(_("%s: Wrong number of input arguments: %d to %d expected.\n"), "polyval", 2, 4);
assert_checkerror("polyval()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in [""double"",""polynomial""].\n"), "polyval", 1);
assert_checkerror("polyval(int8(1), 1)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in ""double"".\n"), "polyval", 2);
assert_checkerror("polyval(1, int8(1))", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: a structure expected.\n"), "polyval", 3);
assert_checkerror("[y, d] = polyval(2, 1, 3)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: a vector expected.\n"), "polyval", 4);
assert_checkerror("y = polyval(2,1,[], 1)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in ""double"".\n"), "polyval", 4);
assert_checkerror("y = polyval(2,1,[], int8([1 2]))", msg);