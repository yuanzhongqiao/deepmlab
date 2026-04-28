// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2022 - UTC - Stéphane Mottelet
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->


// 2D PDE, minimal surface, solve Euler equation

function out=fun(f)
    fx = gradx*f;
    fy = grady*f;
    // equation of mininal surface. Surface is the graph of z=f(x,y)
    // inside domain
    out = (1+fy.*fy).*(lapx*f)+(1+fx.*fx).*(lapy*f)-2*fx.*fy.*(gradx*(grady*f));
    // at the boundary
    out(bdy) = f(bdy)-cnd;
endfunction

function out=jacColor(f,jc)
    out = jc(f);
end

// define square domain [-1,1] x [-1,1]
n = 100;
x=linspace(-1,1,n);
y=x;
[X,Y]=meshgrid(x,x);

// build finite differences operators
dx=x(2)-x(1);
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
sp = lapy+lapx;

// Dirichlet boundary condition
bdy = find(X(:)==x(1) | X(:)==x($) | Y(:)==y(1) | Y(:)==y($))';

// Fix Linear Jacobian lines for bdy nodes
sp(bdy,:)=0;
d = zeros(n*n,1);
d(bdy) = 1;
sp = sp+diag(sparse(d));

alpha=0.5
fBnd = alpha*cos(%pi*X(:)).*cos(%pi*Y(:));
cnd = alpha*fBnd(bdy);

jc=spCompJacobian(fun,sp+grady*gradx);

[f,val,info,s1]=kinsol(fun,ones(n*n,1),jacBand=[n n]);
[f,val,info,s2]=kinsol(fun,ones(n*n,1),jacBand=[n n],method="lineSearch");
[f,val,info,s3]=kinsol(fun,ones(n*n,1),jacobian=sp,method="Picard");
[f,val,info,s4]=kinsol(fun,ones(n*n,1),jacobian=list(jacColor,spCompJacobian(fun,sp+grady*gradx)));

assert_checktrue(s1.stats.nRhsEvals < s3.stats.nRhsEvals)
assert_checktrue(s4.stats.nRhsEvals < s1.stats.nRhsEvals)

assert_checktrue(s1.stats.nJacEvals < s3.stats.nJacEvals)
assert_checkequal(s1.stats.nJacEvals, s4.stats.nJacEvals)
