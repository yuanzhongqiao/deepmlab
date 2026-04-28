// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for pdist2 function
// =============================================================================

function d = euclidean(x, y)
    rx = size(x, 1);
    ry = size(y, 1);
    
    [idx, idy] = meshgrid (1:rx, 1:ry);
    u = x(idx, :);
    v = y(idy, :);

    d = sqrt(sum((u - v) .^ 2, 2));
    d = matrix(d, ry, rx)';
endfunction

function d = seuclidean(x, y, p)
    rx = size(x, 1);
    ry = size(y, 1);
    
    [idx, idy] = meshgrid (1:rx, 1:ry);
    u = x(idx, :);
    v = y(idy, :);

    p(p == 0) = 1;
    param = ones(length(idx), 1) * p;
    d = sqrt(sum(((u-v) ./ param) .^ 2, 2));
    d = matrix(d, ry, rx)';
endfunction

function d = mahalanobis(x, y, p)
    rx = size(x, 1);
    ry = size(y, 1);
    
    [idx, idy] = meshgrid (1:rx, 1:ry);
    u = x(idx, :);
    v = y(idy, :);
    d = sqrt(sum((u - v) * inv(p) .* (u - v), 2));
    d = matrix(d, ry, rx)';
endfunction

function d = minkowski(x, y, p)
    rx = size(x, 1);
    ry = size(y, 1);
    
    [idx, idy] = meshgrid (1:rx, 1:ry);
    u = x(idx, :);
    v = y(idy, :);
    d = sum(abs(u - v) .^ p, 2) .^(1 / p);
    d = matrix(d, ry, rx)';
endfunction

function d = cosine(x, y)
    rx = size(x, 1);
    ry = size(y, 1);
    
    [idx, idy] = meshgrid (1:rx, 1:ry);
    u = x(idx, :);
    v = y(idy, :);
    d = 1 - sum(u .* v, 2)./sqrt(sum(u.^2, 2) .* sum(v.^2, 2));
    d = matrix(d, ry, rx)';
endfunction

function d = correlation(x, y)
    [rx, c] = size(x);
    ry = size(y, 1);
    
    [idx, idy] = meshgrid (1:rx, 1:ry);
    u = x(idx, :);
    v = y(idy, :);

    U = u - mean(u, 2) * ones(1, c);
    V = v - mean(v, 2) * ones(1, c);
    d = 1- (sum(U .* V, 2) ./ sqrt(sum(U.^2, 2) .* sum(V.^2, 2)));
    d = matrix(d, ry, rx)';
endfunction

function d = canberra(x, y)
    rx = size(x, 1);
    ry = size(y, 1);
    
    [idx, idy] = meshgrid (1:rx, 1:ry);
    u = x(idx, :);
    v = y(idy, :);
    d = sum(abs(u-v)./(abs(u) + abs(v)), 2);
    d = matrix(d, ry, rx)';
endfunction

function d = braycurtis(x, y)
    rx = size(x, 1);
    ry = size(y, 1);
    
    [idx, idy] = meshgrid (1:rx, 1:ry);
    u = x(idx, :);
    v = y(idy, :);
    d = sum(abs(u-v), 2)./sum(abs(u + v), 2);
    d = matrix(d, ry, rx)';
endfunction

x = [1 5 4 0.5];
y = [7 2 -1.5 9];

// euclidean
expected = euclidean(x, y);
d = pdist2(x, y);
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "euclidean");
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "euclid");
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "eu");
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "e");
assert_checkalmostequal(d, expected, [], 1e-12);

// sqeuclidian
expected = 147.5;
d = pdist2(x, y, "squaredeuclidean");
assert_checkequal(d, expected);
d = pdist2(x, y, "sqeuclidean");
assert_checkequal(d, expected);
d = pdist2(x, y, "sqe");
assert_checkequal(d, expected);
d = pdist2(x, y, "sqeuclid");
assert_checkequal(d, expected);

// seuclidean
expected = seuclidean(x, y, stdev(x, "r"));
d = pdist2(x, y, "seuclidean");
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "se");
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "s");
assert_checkalmostequal(d, expected, [], 1e-12);

p = 0.1 * ones(1, 4);
expected = seuclidean(x, y, p);
d = pdist2(x, y, "seuclidean", p);
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "se", p);
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "s", p);
assert_checkalmostequal(d, expected, [], 1e-12);

// mahalanobis
expected = mahalanobis(x, y, cov(x));
d = pdist2(x, y, "mahalanobis");
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "mahal");
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "mah");
assert_checkalmostequal(d, expected, [], 1e-12);

p = eye(4,4);
expected = mahalanobis(x, y, p);
d = pdist2(x, y, "mahalanobis", p);
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "mahal", p);
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "mah", p);
assert_checkalmostequal(d, expected, [], 1e-12);

// cityblock
expected = 23;
d = pdist2(x, y, "city");
assert_checkequal(d, expected);
d = pdist2(x, y, "city block");
assert_checkequal(d, expected);
d = pdist2(x, y, "cityblock");
assert_checkequal(d, expected);
d = pdist2(x, y, "cblock");
assert_checkequal(d, expected);
d = pdist2(x, y, "cb");
assert_checkequal(d, expected);

// minkowski
expected = minkowski(x, y, 2);
d = pdist2(x, y, "minkowski");
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "mi");
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "m");
assert_checkalmostequal(d, expected, [], 1e-12);

p = 1;
expected = 23;
d = pdist2(x, y, "minkowski", p);
assert_checkequal(d, expected);
d = pdist2(x, y, "mi", p);
assert_checkequal(d, expected);
d = pdist2(x, y, "m", p);
assert_checkequal(d, expected);

// checbychev
expected = 8.5;
d = pdist2(x, y, "chebychev");
assert_checkequal(d, expected);
d = pdist2(x, y, "chebyshev");
assert_checkequal(d, expected);
d = pdist2(x, y, "cheby");
assert_checkequal(d, expected);
d = pdist2(x, y, "cheb");
assert_checkequal(d, expected);
d = pdist2(x, y, "ch");
assert_checkequal(d, expected);

// cosine
expected = cosine(x, y);
d = pdist2(x, y, "cosine");
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "cos");
assert_checkalmostequal(d, expected, [], 1e-12);

// correlation
expected = correlation(x, y);
d = pdist2(x, y, "correlation");
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "co");
assert_checkalmostequal(d, expected, [], 1e-12);

// hamming
expected = 1;
d = pdist2(x, y, "hamming");
assert_checkequal(d, expected);
d = pdist2(x, y, "hamm");
assert_checkequal(d, expected);
d = pdist2(x, y, "ha");
assert_checkequal(d, expected);
d = pdist2(x, y, "h");
assert_checkequal(d, expected);

// jaccard
d = pdist2(x, y, "jaccard");
assert_checkequal(d, expected);
d = pdist2(x, y, "jacc");
assert_checkequal(d, expected);
d = pdist2(x, y, "ja");
assert_checkequal(d, expected);
d = pdist2(x, y, "j");
assert_checkequal(d, expected);

// canberra
expected = canberra(x, y);
d = pdist2(x, y, "canberra");
assert_checkalmostequal(d, expected, [], 1e-12);

// braycurtis
expected = braycurtis(x, y);
d = pdist2(x, y, "braycurtis");
assert_checkalmostequal(d, expected, [], 1e-12);

// *****************************************************************
// *****************************************************************
// *****************************************************************
x = [1; 5];
y = [7; 2; -1.5; 9];

// euclidean
expected = [6 1 2.5 8;2 3 6.5 4];
d = pdist2(x, y);
assert_checkequal(d, expected);
d = pdist2(x, y, "euclidean");
assert_checkequal(d, expected);
d = pdist2(x, y, "euclid");
assert_checkequal(d, expected);
d = pdist2(x, y, "eu");
assert_checkequal(d, expected);
d = pdist2(x, y, "e");
assert_checkequal(d, expected);

// sqeuclidian
expected = [36 1 6.25 64; 4 9 42.25 16];
d = pdist2(x, y, "squaredeuclidean");
assert_checkequal(d, expected);
d = pdist2(x, y, "sqeuclidean");
assert_checkequal(d, expected);
d = pdist2(x, y, "sqe");
assert_checkequal(d, expected);
d = pdist2(x, y, "sqeuclid");
assert_checkequal(d, expected);

// seuclidean
expected = seuclidean(x, y, stdev(x, "r"));
d = pdist2(x, y, "seuclidean");
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "se");
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "s");
assert_checkalmostequal(d, expected, [], 1e-12);

p = 0.1;
expected = [60 10 25 80; 20 30 65 40];
d = pdist2(x, y, "seuclidean", p);
assert_checkequal(d, expected);
d = pdist2(x, y, "se", p);
assert_checkequal(d, expected);
d = pdist2(x, y, "s", p);
assert_checkequal(d, expected);

// mahalanobis
expected = mahalanobis(x, y, cov(x));
d = pdist2(x, y, "mahalanobis");
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "mahal");
assert_checkalmostequal(d, expected, [], 1e-12);
d = pdist2(x, y, "mah");
assert_checkalmostequal(d, expected, [], 1e-12);

p = 1;
expected = [6 1 2.5 8;2 3 6.5 4];
d = pdist2(x, y, "mahalanobis", p);
assert_checkequal(d, expected);
d = pdist2(x, y, "mahal", p);
assert_checkequal(d, expected);
d = pdist2(x, y, "mah", p);
assert_checkequal(d, expected);

// cityblock
d = pdist2(x, y, "city");
assert_checkequal(d, expected);
d = pdist2(x, y, "city block");
assert_checkequal(d, expected);
d = pdist2(x, y, "cityblock");
assert_checkequal(d, expected);
d = pdist2(x, y, "cblock");
assert_checkequal(d, expected);
d = pdist2(x, y, "cb");
assert_checkequal(d, expected);

// minkowski
d = pdist2(x, y, "minkowski");
assert_checkequal(d, expected);
d = pdist2(x, y, "mi");
assert_checkequal(d, expected);
d = pdist2(x, y, "m");
assert_checkequal(d, expected);

p = 2;
d = pdist2(x, y, "minkowski", p);
assert_checkequal(d, expected);
d = pdist2(x, y, "mi", p);
assert_checkequal(d, expected);
d = pdist2(x, y, "m", p);
assert_checkequal(d, expected);

// checbychev
d = pdist2(x, y, "chebychev");
assert_checkequal(d, expected);
d = pdist2(x, y, "chebyshev");
assert_checkequal(d, expected);
d = pdist2(x, y, "cheby");
assert_checkequal(d, expected);
d = pdist2(x, y, "cheb");
assert_checkequal(d, expected);
d = pdist2(x, y, "ch");
assert_checkequal(d, expected);

// cosine
expected = [0 0 2 0; 0 0 2 0];
d = pdist2(x, y, "cosine");
assert_checkequal(d, expected);
d = pdist2(x, y, "cos");
assert_checkequal(d, expected);

// correlation
expected = %nan * ones(2, 4);
d = pdist2(x, y, "correlation");
assert_checkequal(d, expected);
d = pdist2(x, y, "co");
assert_checkequal(d, expected);

// hamming
expected = ones(2, 4);
d = pdist2(x, y, "hamming");
assert_checkequal(d, expected);
d = pdist2(x, y, "hamm");
assert_checkequal(d, expected);
d = pdist2(x, y, "ha");
assert_checkequal(d, expected);
d = pdist2(x, y, "h");
assert_checkequal(d, expected);

// jaccard
d = pdist2(x, y, "jaccard");
assert_checkequal(d, expected);
d = pdist2(x, y, "jacc");
assert_checkequal(d, expected);
d = pdist2(x, y, "ja");
assert_checkequal(d, expected);
d = pdist2(x, y, "j");
assert_checkequal(d, expected);

// canberra
expected = canberra(x, y);
d = pdist2(x, y, "canberra");
assert_checkalmostequal(d, expected, [], 1e-12);

// braycurtis
expected = braycurtis(x, y);
d = pdist2(x, y, "braycurtis");
assert_checkalmostequal(d, expected, [], 1e-12);


X = [0 0;
     1 0];
Y = [0 1;
     1 1;
     2 2];

D = pdist2(X, Y);
assert_checkequal(size(D), [2 3]);
expected = [1 sqrt(2) sqrt(8);
              sqrt(2) 1 sqrt(5)];
assert_checkalmostequal(D, expected, [], 1d-12);

D = pdist2(X, Y, "sqeuclidean");
assert_checkalmostequal(D, [1 2 8; 2 1 5], [], 1d-12);

D = pdist2(X, Y, "cityblock");
assert_checkalmostequal(D, [1 2 4; 2 1 3], [], 1d-12);

D = pdist2(X, Y, "chebychev");
assert_checkalmostequal(D, [1 1 2; 1 1 2], [], 1d-12);

X = [1 0 2;
    2 4 6];
Y = [3 7 1;
    2 1 5];
scale = [0.5 2 1.5];
D = pdist2(X, Y, "seuclidean", scale);
expected = seuclidean(X, Y, scale);
assert_checkalmostequal(D, expected, [], 1d-12);

d = pdist2(X, Y, "seuclidean");
stdx = stdev(X, "r");
dd = pdist2(X, Y, "seuclidean", stdx);
assert_checkalmostequal(d, dd, [], 1d-12);

X = [1 2;
      3 4];
Y = [0 1;
      5 0];
D = pdist2(X, Y, "minkowski", 3);
expected = minkowski(X, Y, 3);
assert_checkalmostequal(D, expected, [], 1d-12);

X = [1 2;
     3 1;
     2 1];
Y = [0 1;
     2 2];
D = pdist2(X, Y, "mahalanobis");
DD = pdist2(X, Y, "mahalanobis", cov(X));
assert_checkalmostequal(D, DD, [], 1d-11);

X = [1 0 0;
    0 1 0];
Y = [1 1 0;
    1 -1 0];
D = pdist2(X, Y, "cosine");
expected = cosine(X, Y);
assert_checkalmostequal(D, expected, [], 1d-12);

X = [1 2 3 4;
    2 1 4 3];
Y = [4 3 2 1;
    2 0 2 4];
D = pdist2(X, Y, "correlation");
expected = correlation(X, Y);
assert_checkalmostequal(D, expected, [], 1d-12);

X = [0 1 0;
    1 1 0];
Y = [0 1 1;
    1 0 0];
D = pdist2(X, Y, "hamming");
expected = [1/3 2/3;
            2/3 1/3];
assert_checkalmostequal(D, expected, [], 1d-12);

X = [1 0 0;
    1 1 0];
Y = [0 1 0;
        1 0 1];
D = pdist2(X, Y, "jaccard");
expected = [1 0.5;
               0.5 2/3];
assert_checkalmostequal(D, expected, [], 1d-12);

X = [1 2;
    3 4];
Y = [5 0;
    1 1];
D = pdist2(X, Y, "canberra");
expected = [5/3 1/3;
            5/4 11/10];
assert_checkalmostequal(D, expected, [], 1d-12);

D = pdist2(X, Y, "braycurtis");
expected = [0.75 0.2;
            0.5 5/9];
assert_checkalmostequal(D, expected, [], 1d-12);

// checkerror
msg = msprintf(_("%s: Wrong number of input arguments: %d or %d expected.\n"), "pdist2", 2, 4);
assert_checkerror("pdist2(rand(2,2))", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: %s expected.\n"), "pdist2", 1, "double");
assert_checkerror("pdist2(""1"", rand(2,2))", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: %s expected.\n"), "pdist2", 2, "double");
assert_checkerror("pdist2(rand(2,2), ""2"")", msg);

msg = msprintf(_("%s: Wrong size for input argument #%d and #%d: Must have the same number of columns.\n"), "pdist2", 1, 2);
assert_checkerror("pdist2(rand(2,2), rand(2,3))", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: A string or function expected.\n"), "pdist2", 3);
assert_checkerror("pdist2(rand(2,2), rand(2,2), 123)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: invalid distance name ''%s''.\n"), "pdist2", 3, "foo");
assert_checkerror("pdist2(rand(2,2), rand(2,2), ""foo"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: %s expected.\n"), "pdist2", 4, "double");
assert_checkerror("pdist2(rand(2,2), rand(2,2), ""seuclidean"", ""x"")", msg);

msg = msprintf(_("%s: Wrong size for input argument #%d: A row vector of length %d expected for %s distance.\n"), "pdist2", 3, 2, "seuclidean");
assert_checkerror("pdist2(rand(3,2), rand(2,2), ""seuclidean"", ones(1,1))", msg);

msg = msprintf(_("%s: Wrong size for input argument #%d: A scalar expected for %s distance.\n"), "pdist2", 3, "minkowski");
assert_checkerror("pdist2(rand(2,2), rand(2,2), ""minkowski"", [1 2])", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: A positive scalar expected for %s distance.\n"), "pdist2", 3, "minkowski");
assert_checkerror("pdist2(rand(2,2), rand(2,2), ""minkowski"", -1)", msg);
