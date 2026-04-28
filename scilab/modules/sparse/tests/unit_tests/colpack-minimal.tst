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

function out=fun(f)
    global ncall
    fx = gradx*f;
    fy = grady*f;
    // equation of mininal surface. Surface is the graph of z=f(x,y)
    // inside domain
    out = (1+fy.^2).*(lapx*f)+(1+fx.^2).*(lapy*f)-2*fx.*fy.*(gradx*(grady*f));
    // at the boundary
    out(bdy) = f(bdy)-cnd;
    ncall = ncall+1;
endfunction

global ncall

// define square domain [-1,1] x [-1,1]
n = 31;
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

// Dirichlet boundary condition
bdy = find(X(:)==x(1) | X(:)==x($) | Y(:)==y(1) | Y(:)==y($))';
cnd = .5*cos(2*%pi*X(bdy)).*cos(2*%pi*Y(bdy));

// sparsity pattern
sp = lapy+lapx+grady*gradx;

// initial value of iterate
f0 = zeros(n^2,1)

// build colored Jacobian engine
jacobian = spCompJacobian(fun,sp,FiniteDifferenceType="COMPLEXSTEP");

// Solve with Newton method using colored Jacobian
ncall = 0;    
f = f0;
for i=1:100
    df = umfpack(jacobian(f),"\",fun(f));
    f = f-df;
    if norm(df)/norm(f) < 1e-8
        break
    end
end
assert_checkequal(ncall,84)

ncall=0;
f=f0;
ff = fsolve(f0,fun);
ncall2=ncall;
assert_checkequal(ncall,9728)
