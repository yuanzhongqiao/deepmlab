// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for meanshift function
// =============================================================================

rand("seed", 0)
x = [2 3; 4 4; 1 4; 2 1; 4 3; 4 2; 5 2; 1 2; 5 1; 3 4];
[c, l] = meanshift(x, 2);

assert_checkequal(l, [2 1 2 2 1 1 1 2 1 1]');
assert_checkalmostequal(c, [3.666666666 3; 1.5 2.5]);

rand("seed", 0)
n = 10;
X1 = [rand(n, 2) + 1; rand(n, 2) + 5];
[c, l] = meanshift(X1, 2);

assert_checkequal(size(l), [20 1]);
assert_checkalmostequal(c, [5.439643 5.4368296; 1.5073757 1.4907992], [], 10^-7);

X = [0 0; 0 1; 1 0; 5 5; 5 6; 6 5; 9 9; 9 10; 10 9];
bw = estimate_bandwidth(X);
[centers, labels] = meanshift(X, bw);

assert_checkequal(size(labels), [9 1]);
assert_checkequal(labels, [3 3 3 2 2 2 1 1 1]');
assert_checkalmostequal(centers, [9.33333333 9.33333333; 5.33333333 5.33333333; 0.33333333 0.33333333], [], 10^-7);

opts.kernel = "flat";
[centers, labels] = meanshift(X, bw, opts);
assert_checkequal(size(labels), [9 1]);
assert_checkequal(labels, [3 3 3 2 2 2 1 1 1]');
assert_checkalmostequal(centers, [9.33333333 9.33333333; 5.33333333 5.33333333; 0.33333333 0.33333333], [], 10^-7);

opts.kernel = "gaussian";
[centers, labels] = meanshift(X, bw, opts);
assert_checkequal(size(labels), [9 1]);
assert_checkequal(labels, [3 3 3 1 1 1 2 2 2]');
assert_checkalmostequal(centers, [5.3213237, 5.3213237; 9.3205258 9.3205258; 0.3208931, 0.3208931], [], 10^-7);

opts = struct("seeds", [9.5 9.5;5.5 5.5; 0.5 0.5]);
[centers, labels] = meanshift(X, bw, opts);
assert_checkequal(labels, [3 3 3 2 2 2 1 1 1]');
assert_checkalmostequal(centers, [9.33333333 9.33333333; 5.33333333 5.33333333; 0.33333333 0.33333333], [], 10^-7);

opts.kernel = "gaussian";
[centers, labels] = meanshift(X, bw, opts);
assert_checkequal(labels, [3 3 3 1 1 1 2 2 2]');

// checkerror
msg = msprintf(_("%s: Wrong number of input arguments: %d to %d expected.\n"), "meanshift", 1, 3);
assert_checkerror("meanshift()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in ""%s"".\n"), "meanshift", 1, "double");
assert_checkerror("meanshift(""1"", 2)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in ""%s"".\n"), "meanshift", 2, "double");
assert_checkerror("meanshift(1, ""2"")", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Non negative numbers expected.\n"), "meanshift", 2);
assert_checkerror("meanshift(x, -1)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in ""%s"".\n"), "meanshift", 3, "struct");
assert_checkerror("meanshift(x, 1, 1)", msg);

opts = struct("seed", [1 1]);
msg = msprintf(_("%s: Unknown option(s): %s"), "meanshift", sci2exp("seed"));
assert_checkerror("meanshift(x, 1, opts)", msg);
