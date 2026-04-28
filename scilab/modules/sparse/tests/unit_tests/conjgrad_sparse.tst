// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Paul Bignier: added cgs, bicg and bicgstab
// Copyright (C) 2008 - INRIA - Michael Baudin
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->

//------------------------------------------------------------------
// PCG

// Numerical tests
// Case where A is sparse
A=[ 94  0   0   0    0   28  0   0   32  0
0   59  13  5    0   0   0   10  0   0
0   13  72  34   2   0   0   0   0   65
0   5   34  114  0   0   0   0   0   55
0   0   2   0    70  0   28  32  12  0
28  0   0   0    0   87  20  0   33  0
0   0   0   0    28  20  71  39  0   0
0   10  0   0    32  0   39  46  8   0
32  0   0   0    12  33  0   8   82  11
0   0   65  55   0   0   0   0   11  100];
b = [154.
87.
186.
208.
144.
168.
158.
135.
178.
231.];
Asparse = sparse(A);
// With the default 10 iterations, the algorithm performs well
[xcomputed, fail, err, iter, res]=conjgrad(Asparse,b,"pcg");
xexpected=ones(10,1);
assert_checkalmostequal(xcomputed, xexpected);
assert_checkequal(fail, 0);
assert_checkequal(iter, 10);
assert_checktrue(err < 1e-12);

//------------------------------------------------------------------
// CGS

// CGS needs 11 iterations to converge
[xcomputed, fail, err, iter, res]=conjgrad(Asparse,b,"cgs",maxIter=11);
assert_checkalmostequal(xcomputed, xexpected);
assert_checkequal(fail, 0);
assert_checkequal(iter, 11);
assert_checktrue(err < 1e-11);

//------------------------------------------------------------------
// BICG

// With the default 10 iterations, the algorithm performs well
[xcomputed, fail, err, iter, res]=conjgrad(Asparse,b,"bicg");
assert_checkalmostequal(xcomputed, xexpected);
assert_checkequal(fail, 0);
assert_checkequal(iter, 10);
assert_checktrue(err < 1e-12);

//------------------------------------------------------------------
// BICGSTAB

// BICGSTAB only needs 8 iterations to converge to the required tol, but is less accurate on arrival.
[xcomputed, fail, err, iter, res]=conjgrad(Asparse,b,"bicgstab");
assert_checkalmostequal(xcomputed, xexpected, 1e-6);
assert_checkequal(fail, 0);
assert_checkequal(iter, 8);
assert_checktrue(err < 1e-8);
