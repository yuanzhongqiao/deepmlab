// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15701 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15701
//
// <-- Short Description -->
// A\B is not faster when A is square and triangular

N = 3000;
// matrix A with good condition number in order to prevent
// least squares solution
A=tril(rand(N,N))+10*eye(N,N);
B=rand(N,1);

// general case
A(1,N)=%eps;
timer();
x1=A\B;
t1=timer()

// triangular case
A(1,N)=0;
timer();
x2=A\B;
t2=timer()
assert_checkalmostequal(x1,x2);
assert_checktrue(t1/t2 > 2);

// complex case
A=A+%i*tril(rand(N,N));
B=B+%i*rand(N,1);

// general case
A(1,N)=%eps;
timer();
x1=A\B;
t1=timer()

// triangular case
A(1,N)=0;
timer();
x2=A\B;
t2=timer()

assert_checkalmostequal(x1,x2);
assert_checktrue(t1/t2 > 2);
