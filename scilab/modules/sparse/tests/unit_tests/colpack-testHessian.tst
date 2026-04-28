//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

function y=g(x)
    y = A*x;
end

grand("setsd",23)
N = 100;
A = sprand(N,N,0.02);
A=A+A';
x0 = rand(N,1);

sp = A<>0;
ij = spget(sp);

// get computation engine
hessian = spCompHessian(g,sp,Coloring="STAR",FiniteDifferenceType="COMPLEXSTEP",Vectorized="on");
col = hessian.colors;
// compute Hessian with new implementation
H3 = hessian(x0) ;

assert_checkequal(size(hessian.seed,2),9);
assert_checkequal(H3,A);
