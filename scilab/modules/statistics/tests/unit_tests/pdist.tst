// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for pdist function
// =============================================================================

function d = seuclidean(x, idx, idy, p)
    u = x(idx, :);
    v = x(idy, :);
    param = ones(length(idx), 1) * p;
    d = sqrt(sum(((u-v) ./ param) .^ 2, 2))';
endfunction

function d = mahalanobis(x, idx, idy, p)
    u = x(idx, :);
    v = x(idy, :);
    d = sqrt(sum((u - v) * inv(p) .* (u - v), 2))';
endfunction

function d = minkowski(x, idx, idy, p)
    u = x(idx, :);
    v = x(idy, :);
    d = sum(abs(u - v) .^ p, 2)' .^(1 / p);
endfunction

function d = cosine(x, idx, idy)
    u = x(idx, :);
    v = x(idy, :);
    d = 1 - sum(u .* v, 2)./sqrt(sum(u.^2, 2) .* sum(v.^2, 2));
    d = d';
endfunction

function d = correlation(x, idx, idy)
    u = x(idx, :);
    v = x(idy, :);
    c = size(x, 2);
    U = u - mean(u, 2) * ones(1, c);
    V = v - mean(v, 2) * ones(1, c);
    d = 1- (sum(U .* V, 2) ./ sqrt(sum(U.^2, 2) .* sum(V.^2, 2)));
    d = d';
endfunction

function d = canberra(x, idx, idy)
    u = x(idx, :);
    v = x(idy, :);
    d = sum(abs(u-v)./(abs(u) + abs(v)), 2)';
endfunction

function d = braycurtis(x, idx, idy)
    u = x(idx, :);
    v = x(idy, :);
    d = sum(abs(u-v), 2)./sum(abs(u + v), 2);
    d = d';
endfunction

// with x is vector
x = [1; 5; 4; 0.5; 7; 2; -1.5; 9];
idx = [1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 6, 6, 7];
idy = [2, 3, 4, 5, 6, 7, 8, 3, 4, 5, 6, 7, 8, 4, 5, 6, 7, 8, 5, 6, 7, 8, 6, 7, 8, 7, 8, 8];

// distance euclidian
expected = [4; 3; 0.5; 6; 1; 2.5; 8; 1; 4.5; 2; 3; 6.5; 4; 3.5; 3; 2; 5.5; 5; 
6.5; 1.5; 2; 8.5; 5; 8.5; 2; 3.5; 7; 10.5]';

d = pdist(x);
assert_checkequal(d, expected);
d = pdist(x, "euclidean");
assert_checkequal(d, expected);
d = pdist(x, "euclid");
assert_checkequal(d, expected);
d = pdist(x, "eu");
assert_checkequal(d, expected);
d = pdist(x, "e");
assert_checkequal(d, expected);

// distance sqeuclidian
expected = [16; 9; 0.25; 36; 1; 6.25; 64; 1; 20.25; 4; 9; 42.25; 16; 12.25; 9; 4; 30.25; 25; 42.25; 2.25; 
4; 72.25; 25; 72.25; 4; 12.25; 49; 110.25]';

d = pdist(x, "squaredeuclidean");
assert_checkequal(d, expected);
d = pdist(x, "sqeuclidean");
assert_checkequal(d, expected);
d = pdist(x, "sqe");
assert_checkequal(d, expected);
d = pdist(x, "sqeuclid");
assert_checkequal(d, expected);

// distance seuclidian
expected = seuclidean(x, idx, idy, stdev(x, 1));
d = pdist(x, "seuclidean");
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist(x, "se");
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist(x, "s");
assert_checkalmostequal(d, expected, [], 1e-12);

p = 0.1;
expected = [40 30 5 60 10 25 80 10 45 20 30 65 40 35 30 20 55 50 65 15 20 85 50 85 20 35 70 105];

d = pdist(x, "seuclidean", p);
assert_checkequal(d, expected);
d = pdist(x, "se", p);
assert_checkequal(d, expected);
d = pdist(x, "s", p);
assert_checkequal(d, expected);

// distance mahalanobis
expected = mahalanobis(x, idx, idy, cov(x));
d = pdist(x, "mahalanobis");
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist(x, "mahal");
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist(x, "mah");
assert_checkalmostequal(d, expected, [], 1e-12);

expected = mahalanobis(x, idx, idy, p);
d = pdist(x, "mahalanobis", p);
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist(x, "mahal", p);
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist(x, "mah", p);
assert_checkalmostequal(d, expected, [], 1e-12);

// distance cityblock
expected = [4 3 0.5 6 1 2.5 8 1 4.5 2 3 6.5 4 3.5 3 2 5.5 5 6.5 1.5 2 8.5 5 8.5 2 3.5 7 10.5];
d = pdist(x, "city");
assert_checkequal(d, expected);
d = pdist(x, "city block");
assert_checkequal(d, expected);
d = pdist(x, "cityblock");
assert_checkequal(d, expected);
d = pdist(x, "cblock");
assert_checkequal(d, expected);
d = pdist(x, "cb");
assert_checkequal(d, expected);

// distance minkowski
d = pdist(x, "minkowski");
assert_checkequal(d, expected);
d = pdist(x, "mi");
assert_checkequal(d, expected);
d = pdist(x, "m");
assert_checkequal(d, expected);

// distance checbychev
d = pdist(x, "chebychev");
assert_checkequal(d, expected);
d = pdist(x, "chebyshev");
assert_checkequal(d, expected);
d = pdist(x, "cheby");
assert_checkequal(d, expected);
d = pdist(x, "cheb");
assert_checkequal(d, expected);
d = pdist(x, "ch");
assert_checkequal(d, expected);

// distance cosine
expected = [0 0 0 0 0 2 0 0 0 0 0 2 0 0 0 0 2 0 0 0 2 0 0 2 0 2 0 2];
d = pdist(x, "cosine");
assert_checkequal(d, expected);
d = pdist(x, "cos");
assert_checkequal(d, expected);

// distance correlation
expected = %nan * ones(1, 28);
d = pdist(x, "correlation");
assert_checkequal(d, expected);
d = pdist(x, "co");
assert_checkequal(d, expected);

// distance hamming
expected = ones(1, 28);
d = pdist(x, "hamming");
assert_checkequal(d, expected);
d = pdist(x, "hamm");
assert_checkequal(d, expected);
d = pdist(x, "ha");
assert_checkequal(d, expected);
d = pdist(x, "h");
assert_checkequal(d, expected);

// distance jaccard
d = pdist(x, "jaccard");
assert_checkequal(d, expected);
d = pdist(x, "jacc");
assert_checkequal(d, expected);
d = pdist(x, "ja");
assert_checkequal(d, expected);
d = pdist(x, "j");
assert_checkequal(d, expected);

// distance canberra
expected = canberra(x, idx, idy);
d = pdist(x, "canberra");
assert_checkalmostequal(d, expected, [], 1e-12);

// distance braycurtis
expected = braycurtis(x, idx, idy);
d = pdist(x, "braycurtis");
assert_checkalmostequal(d, expected, [], 1e-12);

// euclidean, sqeuclidean, cityblock, checbychev
X = [0 0;
     1 0;
     0 2;
     1 2];

d = pdist(X);
assert_checkequal(size(d), [1 6]);
assert_checkalmostequal(d, [1 2 sqrt(5) sqrt(5) 2 1]);

d = pdist(X, "euclidean");
assert_checkequal(size(d), [1 6]);
assert_checkalmostequal(d, [1 2 sqrt(5) sqrt(5) 2 1]);

d = pdist(X, "sqeuclidean");
assert_checkalmostequal(d, [1 4 5 5 4 1], [], 1d-12);

d = pdist(X, "cityblock");
assert_checkalmostequal(d, [1 2 3 3 2 1], [], 1d-12);

d = pdist(X, "chebychev");
assert_checkalmostequal(d, [1 2 2 2 2 1], [], 1d-12);

// seuclidean
X = [1 0 2;
     2 4 6;
     3 7 1];
scale = [0.5 2 1.5];
d = pdist(X, "seuclidean", scale);

idx = [1 1 2];
idy = [2 3 3];
expected = seuclidean(X, idx, idy, scale);
assert_checkalmostequal(d, expected, [], 1d-12);

d = pdist(X, "seuclidean");
Xstd = stdev(X, "r");
dd = pdist(X, "seuclidean", Xstd);
assert_checkalmostequal(d, dd, [], 1d-12);

// minkowski
X = [1 2;
     3 4;
     5 0];
d = pdist(X, "minkowski", 3);
expected = minkowski(X, idx, idy, 3);
assert_checkalmostequal(d, expected, [], 1d-12);

// mahalanobis
X = [1 2;
     3 0;
     0 1;
     2 2];
d = pdist(X, "mahalanobis");
covX = cov(X);
dd = pdist(X, "mahalanobis", covX);
assert_checkalmostequal(d, dd, [], 1d-11);

// cosine
X = [1 0 0;
      0 1 0;
      1 1 0];
d = pdist(X, "cosine");
expected = cosine(X, idx, idy);
assert_checkalmostequal(d, expected, [], 1d-12);

// correlation
X = [1 2 3 4;
      2 4 8 16;
      1 3 5 7];
d = pdist(X, "correlation");
expected = correlation(X, idx, idy);
assert_checkalmostequal(d, expected, [], 1d-12);

// hamming
X = [0 1 0;
      0 1 1;
      1 0 0];
d = pdist(X, "hamming");
expected = [1/3 2/3 1];
assert_checkalmostequal(d, expected, [], 1d-12);

// jaccard
X = [1 0 0;
      1 1 0;
      0 1 1];
d = pdist(X, "jaccard");
expected = [0.5 1 2/3];
assert_checkalmostequal(d, expected, [], 1d-12);

// canberra
X = [1 2;
       3 4;
       5 0];
d = pdist(X, "canberra");
expected = [5/6 5/3 5/4];
assert_checkalmostequal(d, expected, [], 1d-12);

d = pdist(X, "braycurtis");
expected = [0.4 0.75 0.5];
assert_checkalmostequal(d, expected, [], 1d-12);

// checkerror
msg = msprintf(_("%s: Wrong number of input argument(s): %d or %d expected.\n"), "pdist", 1, 3);
assert_checkerror("pdist()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: %s expected.\n"), "pdist", 1, "double");
assert_checkerror("pdist(""1"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: A string or function expected.\n"), "pdist", 2);
assert_checkerror("pdist(rand(3,3), 123)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: invalid distance name ''%s''.\n"), "pdist", 2, "foo");
assert_checkerror("pdist(rand(3,3), ""foo"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: %s expected.\n"), "pdist", 3, "double");
assert_checkerror("pdist(rand(3,3), ""seuclidean"", ""x"")", msg);

msg = msprintf(_("%s: Wrong size for input argument #%d: A row vector of length %d expected for %s distance.\n"), "pdist", 3, 3, "seuclidean");
assert_checkerror("pdist(rand(3,3), ""seuclidean"", ones(1,2))", msg);

msg = msprintf(_("%s: Wrong size for input argument #%d: A scalar expected for %s distance.\n"), "pdist", 3, "minkowski");
assert_checkerror("pdist(rand(3,3), ""minkowski"", [1 2])", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: A positive scalar expected for %s distance.\n"), "pdist", 3, "minkowski");
assert_checkerror("pdist(rand(3,3), ""minkowski"", -1)", msg);
