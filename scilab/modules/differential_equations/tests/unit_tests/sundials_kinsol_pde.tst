// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->


// 2D PDE,  d^2 f / dx^2 + d^2 f / dy^2 = f^3 - f - 2.0
function out=fun(f)
    out = LAP*f - f.*f.*f + f + 2;
    // at the boundary
    out(bdy) = f(bdy);
endfunction

function out=jac(f)
    d = -3*f.*f+1;
    d(bdy) = 0;
    out = LAPJ+diag(sparse(d))
endfunction

// define square domain [-1,1] x [-1,1]
n = 50;
x=linspace(-1,1,n);
y=x;
[X,Y]=meshgrid(x,x);

// build finite differences operators
dx=x(2)-x(1);
d1x=sparse(ones(n-1,1));
d0x=sparse(ones(n,1));
lap = (diag(d1x,-1)+diag(d1x,1)-2*diag(d0x))/dx/dx;
// use Kronecker product to build matrix of d/dx^2 and d/dy^2
LAP = lap .*. speye(n,n) + speye(n,n) .*. lap;
LAPJ = LAP;

// Dirichlet boundary condition
bdy = find(X(:)==x(1) | X(:)==x($) | Y(:)==y(1) | Y(:)==y($))';

// Fix Linear Jacobian lines for bdy nodes
LAPJ(bdy,:)=0;
d = zeros(n*n,1);
d(bdy) = 1;
LAPJ = LAPJ+diag(sparse(d));

// internal SUNDIALS finite differences Jacobian
[f,val,info,s0]=kinsol(fun,ones(n*n,1),display="iter");
// true Jacobian
[f,val,info,s1]=kinsol(fun,ones(n*n,1),jacobian=jac,display="iter");
// frozen Jacobian
[f,val,info,s2]=kinsol(fun,ones(n*n,1),jacobian=LAPJ,display="iter");
// ColPack Jacobian using only sparsity pattern
[f,val,info,s3]=kinsol(fun,ones(n*n,1),jacPattern=LAPJ,display="iter");

assert_checkequal(s0.stats.nIters,11)
assert_checkequal(s1.stats.nIters,11)
assert_checkequal(s2.stats.nIters,5)
assert_checkequal(s3.stats.nIters,11)
assert_checkequal(s0.stats.nRhsEvalsFD,5000)
assert_checkequal(s3.stats.nRhsEvalsFD,14)


