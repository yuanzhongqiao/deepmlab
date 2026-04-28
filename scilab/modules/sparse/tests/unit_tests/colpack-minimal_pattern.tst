//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

function out=fun(f)
    out = zeros(f);
endfunction
    // define square domain [-1,1] x [-1,1]
n = 7;
// build finite differences operators
dx=1;
d1x=sparse(ones(n-1,1));
d0x=sparse(ones(n,1));
grad = (-diag(d1x,-1) + diag(d1x,1) )/2/dx;
// use Kronecker product to build matrix of d/dx and d/dy
gradx = grad .*. speye(n,n);
grady = speye(n,n) .*. grad;
lap = (diag(d1x,-1)+diag(d1x,1)-2*diag(d0x))/dx^2;
// use Kronecker product to build matrix of d/dx^2 and d/dy^2
lapx = lap .*. speye(n,n);
lapy = speye(n,n) .*. lap;

// sparsity pattern
sp = lapy+lapx+grady*gradx;
ij = spget(sp);
// build colored Jacobian engine
jacobian = spCompJacobian(fun,sp);

assert_checkequal(jacobian.Ordering,"SMALLEST_LAST");
assert_checkequal(jacobian.Coloring,"COLUMN_PARTIAL_DISTANCE_TWO");

assert_checkequal(jacobian.seed,...
[   0.   0.   1.   0.   0.   0.   0.   0.   0.   0.
    0.   0.   0.   0.   0.   0.   0.   1.   0.   0.
    0.   0.   0.   0.   0.   0.   0.   0.   1.   0.
    1.   0.   0.   0.   0.   0.   0.   0.   0.   0.
    0.   1.   0.   0.   0.   0.   0.   0.   0.   0.
    0.   0.   0.   0.   0.   0.   0.   0.   1.   0.
    0.   0.   1.   0.   0.   0.   0.   0.   0.   0.
    0.   0.   0.   0.   0.   1.   0.   0.   0.   0.
    0.   1.   0.   0.   0.   0.   0.   0.   0.   0.
    0.   0.   0.   0.   1.   0.   0.   0.   0.   0.
    0.   0.   1.   0.   0.   0.   0.   0.   0.   0.
    0.   0.   0.   1.   0.   0.   0.   0.   0.   0.
    0.   0.   0.   0.   1.   0.   0.   0.   0.   0.
    0.   0.   0.   0.   0.   1.   0.   0.   0.   0.
    1.   0.   0.   0.   0.   0.   0.   0.   0.   0.
    0.   0.   0.   1.   0.   0.   0.   0.   0.   0.
    0.   0.   0.   0.   0.   0.   1.   0.   0.   0.
    0.   0.   0.   0.   0.   1.   0.   0.   0.   0.
    0.   0.   0.   0.   0.   0.   0.   1.   0.   0.
    0.   0.   0.   0.   0.   0.   1.   0.   0.   0.
    1.   0.   0.   0.   0.   0.   0.   0.   0.   0.
    0.   0.   1.   0.   0.   0.   0.   0.   0.   0.
    0.   0.   0.   0.   0.   0.   0.   1.   0.   0.
    0.   0.   0.   0.   0.   0.   0.   0.   1.   0.
    1.   0.   0.   0.   0.   0.   0.   0.   0.   0.
    0.   1.   0.   0.   0.   0.   0.   0.   0.   0.
    0.   0.   0.   0.   0.   0.   0.   0.   1.   0.
    0.   0.   1.   0.   0.   0.   0.   0.   0.   0.
    0.   0.   0.   0.   0.   1.   0.   0.   0.   0.
    0.   1.   0.   0.   0.   0.   0.   0.   0.   0.
    0.   0.   0.   0.   1.   0.   0.   0.   0.   0.
    0.   0.   1.   0.   0.   0.   0.   0.   0.   0.
    0.   0.   0.   1.   0.   0.   0.   0.   0.   0.
    0.   0.   0.   0.   1.   0.   0.   0.   0.   0.
    0.   0.   0.   0.   0.   1.   0.   0.   0.   0.
    0.   0.   0.   0.   0.   0.   1.   0.   0.   0.
    0.   0.   0.   1.   0.   0.   0.   0.   0.   0.
    0.   0.   0.   0.   0.   0.   0.   0.   0.   1.
    0.   0.   0.   0.   0.   1.   0.   0.   0.   0.
    0.   0.   0.   0.   0.   0.   1.   0.   0.   0.
    0.   0.   0.   0.   0.   0.   0.   0.   0.   1.
    1.   0.   0.   0.   0.   0.   0.   0.   0.   0.
    0.   0.   1.   0.   0.   0.   0.   0.   0.   0.
    0.   0.   0.   0.   0.   0.   0.   0.   1.   0.
    1.   0.   0.   0.   0.   0.   0.   0.   0.   0.
    0.   0.   0.   0.   0.   0.   0.   1.   0.   0.
    0.   1.   0.   0.   0.   0.   0.   0.   0.   0.
    0.   0.   0.   0.   0.   0.   0.   0.   1.   0.
    0.   0.   1.   0.   0.   0.   0.   0.   0.   0.]);

assert_checkequal(jacobian.colors,...
[  3.
   8.
   9.
   1.
   2.
   9.
   3.
   6.
   2.
   5.
   3.
   4.
   5.
   6.
   1.
   4.
   7.
   6.
   8.
   7.
   1.
   3.
   8.
   9.
   1.
   2.
   9.
   3.
   6.
   2.
   5.
   3.
   4.
   5.
   6.
   7.
   4.
   10.
   6.
   7.
   10.
   1.
   3.
   9.
   1.
   8.
   2.
   9.
   3.]);
