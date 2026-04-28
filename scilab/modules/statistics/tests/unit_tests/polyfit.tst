// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for polyfit function
// =============================================================================

assert_checkequal(polyfit(1, 1, 0), 1);

x = 0:5;
y = #(x) -> (2*x);
p = polyfit(x, y(x), 1);
expected = [2 0];
assert_checkalmostequal(p, expected, [], 1e-14);
p = polyfit(x, y(x), %s);
expected = 2*%s;
assert_checkalmostequal(p, expected, [], 1e-14);

[p, S, mu] = polyfit(x, y(x), 1);
assert_checkalmostequal(S.R, [0 -2.449489742783177881336; 2.2360679774997898050515 0], [], 1e-14);
assert_checkequal(S.df, 4);
assert_checkalmostequal(S.normr, 2.5510983e-15, [], 1e-14);
assert_checkequal(mu, [mean(x), stdev(x)]);

y = #(x) -> (x .* (-2 + x));
p = polyfit(x, y(x), 2);
expected = [1 -2 0];
assert_checkalmostequal(p, expected, [], 1e-14);
p = polyfit(x, y(x), %s^2);
expected = -2*%s + %s^2;
assert_checkalmostequal(p, expected, [], 1e-14);

y = #(x) -> (x.^3 - 3*x.^2 + 2*x + 4);
p = polyfit(x, y(x), 3);
expected = [1 -3 2 4];
assert_checkalmostequal(p, expected, [], 1e-14);
p = polyfit(x, y(x), %s^3);
expected = 4 + 2*%s -3*%s^2 + %s^3;
assert_checkalmostequal(p, expected, [], 1e-14);

y = #(x) -> (x.^5 + x - 3);
p = polyfit(x, y(x), 5);
expected = [1 0 0 0 1 -3];
assert_checkalmostequal(p, expected, [], 1e-11);
p = polyfit(x, y(x), %s^5);
expected = -3 + %s +%s^5;
assert_checkalmostequal(p, expected, [], 1e-11);

// with weights
y = [2 5 9 1 3 6];
w = [0.1 0.3 1 0.04 0.6 0.02];
p = polyfit(x, y, 2, w);
expected = [-1.9660409483297, 8.8573392878916, -0.9296599543285];
assert_checkalmostequal(p, expected, [], 1e-11);

// checkerror
msg = msprintf(_("%s: Wrong number of input arguments: %d to %d expected.\n"), "polyfit", 3, 4);
assert_checkerror("polyfit()", msg);

msg = msprintf(_("%s: Wrong size of input arguments #%d and #%d: Must have the same size.\n"), "polyfit", 1, 2);
assert_checkerror("polyfit(0:5, 1, 1)", msg);

msg = msprintf(_("%s: Wrong size of input arguments #%d and #%d: Must have the same size.\n"), "polyfit", 1, 2);
assert_checkerror("polyfit(1, 0:5, 1)", msg);

msg = msprintf(_("%s: Wrong size of input argument #%d: 1 x 1 expected.\n"), "polyfit", 3);
assert_checkerror("polyfit(1, 1, 0:2)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Integer numbers expected.\n"), "polyfit", 3);
assert_checkerror("polyfit(1, 1, 0.5)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Non negative numbers expected.\n"), "polyfit", 3);
assert_checkerror("polyfit(1, 1, -2)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in ""double"".\n"), "polyfit", 4);
assert_checkerror("polyfit(1, 1, 1, ""1"")", msg);

msg = msprintf(_("%s: Wrong size of input arguments #%d and #%d: Must have the same size.\n"), "polyfit", 1, 4);
assert_checkerror("polyfit(1, 1, 1, [])", msg);