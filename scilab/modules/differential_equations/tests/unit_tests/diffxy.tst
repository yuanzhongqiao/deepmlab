// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for diffxy function
// =============================================================================

assert_checkequal(diffxy([], []), []);

x = linspace(-%pi, %pi, 1e3);
y = cos(x);
df = -sin(x);

dydx = diffxy(x, y);
assert_checkalmostequal(dydx, df, [], 1.e-5);

dydx = diffxy(x, y, 1, 2);
assert_checkalmostequal(dydx, df, [], 1.e-5);

dydx = diffxy(x, y, 1, 1);
assert_checkequal(dydx, []);

X = x';
dydx = diffxy(X, y);
assert_checkalmostequal(dydx, df, [], 1.e-5);

dydx = diffxy(X, y, 1, 2);
assert_checkalmostequal(dydx, df, [], 1.e-5);

dydx = diffxy(X, y, 1, 1);
assert_checkequal(dydx, []);

Y = y';
df = df';
dydx = diffxy(x, Y);
assert_checkalmostequal(dydx, df, [], 1.e-5);

dydx = diffxy(x, Y, 1, 1);
assert_checkalmostequal(dydx, df, [], 1.e-5);

dydx = diffxy(x, Y, 1, 2);
assert_checkequal(dydx, []);

x = linspace(-%pi, %pi, 50);
x = matrix(x, 5, 10);

y = cos(x);
df = -sin(x);

dydx = diffxy(x, y);
assert_checkalmostequal(dydx, df, [], 1.e-2);

dydx = diffxy(x, y, 1, 1);
assert_checkalmostequal(dydx, df, [], 1.e-2);

n = 1e3;
x = linspace(-%pi, %pi, n) + rand(1, n, "normal") * 0.1;
y = cos(x);
df = -sin(x);

dydx = diffxy(x, y);
assert_checkalmostequal(dydx, df, [], 1.e-1);

dydx = diffxy(x, y, 1, 2);
assert_checkalmostequal(dydx, df, [], 1.e-1);

dydx = diffxy(x, y, 1, 1);
assert_checkequal(dydx, []);

X = x';
dydx = diffxy(X, y);
assert_checkalmostequal(dydx, df, [], 1.e-1);

dydx = diffxy(X, y, 1, 2);
assert_checkalmostequal(dydx, df, [], 1.e-1);

dydx = diffxy(X, y, 1, 1);
assert_checkequal(dydx, []);

Y = y';
df = df';
dydx = diffxy(x, Y);
assert_checkalmostequal(dydx, df, [], 1.e-1);

dydx = diffxy(x, Y, 1, 1);
assert_checkalmostequal(dydx, df, [], 1.e-1);

dydx = diffxy(x, Y, 1, 2);
assert_checkequal(dydx, []);

x = linspace(-%pi, %pi, 50) + rand(1, 50, "normal") * 0.1;
x = matrix(x, 5, 10);

y = cos(x);
df = -sin(x);

dydx = diffxy(x, y);
assert_checkalmostequal(dydx, df, [], 1.e-1);

dydx = diffxy(x, y, 1, 1);
assert_checkalmostequal(dydx, df, [], 1.e-1);

// checkerror
msg = msprintf(_("%s: Wrong number of input arguments: %d to %d expected.\n"), "diffxy", 2, 4);
assert_checkerror("diffxy()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "diffxy", 1, sci2exp("double"));
assert_checkerror("diffxy(""str"", 1)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "diffxy", 2, sci2exp("double"));
assert_checkerror("diffxy(1, ""str"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "diffxy", 3, sci2exp("double"));
assert_checkerror("diffxy(x, y, ""str"")", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Positive numbers expected.\n"), "diffxy", 3);
assert_checkerror("diffxy(x, y, -1)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Integer numbers expected.\n"), "diffxy", 3);
assert_checkerror("diffxy(x, y, 1.5)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be a scalar.\n"), "diffxy", 3);
assert_checkerror("diffxy(x, y, [1 2])", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "diffxy", 4, sci2exp(["double", "string"]));
assert_checkerror("diffxy(x, y, 1, uint8(1))", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Must be in the set %s.\n"), "diffxy", 4, sci2exp({1, 2, "r", "c"}));
assert_checkerror("diffxy(x, y, 1, ""t"")", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Non-negative numbers expected.\n"), "diffxy", 4, sci2exp({1, 2, "r", "c"}));
assert_checkerror("diffxy(x, y, 1, 0)", msg);