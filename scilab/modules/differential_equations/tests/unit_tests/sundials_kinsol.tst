// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2022 - UTC - Stéphane Mottelet
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// BASIC ROOT
function y=f(x); y=x*x-2;end; 
function j=jac(x); j=2*x;end
function out=cb(x,st,s);out=%f;mprintf("%g\n",x);end
[x,fx,info,stats] = kinsol(f,1,jacobian=jac,callback=cb)

// BASIC n=2
function F=fun(x)
    F = [2*x(1)-x(2)-exp(-x(1));
          -x(1)+2*x(2)-exp(-2*x(2))];
end
x=kinsol(fun,[0;0]);
assert_checkalmostequal(x,[ 
   0.526259961270820419976
   0.461709425677216900308]);


// TRIANGULATION
function f = fGPS(X)
    f = [norm(X-S1)^2 - d1^2
         norm(X-S2)^2 - d2^2
         norm(X-S3)^2 - d3^2];
end
function dfdx = jGPS(X)
    dfdx = 2*[(X-S1)'; (X-S2)'; (X-S3)'];
end

S1 = [-11716.227778,-10118.754628,21741.083973]';
S2 = [-12082.643974, -20428.242179, 11741.374154]';
S3 = [14373.286650, -10448.439349, 19596.404858]';
d1 = 22163.847742;
d2 = 21492.777482;
d3 = 21492.469326;
x=kinsol(fGPS,[0;0;6369])
assert_checkalmostequal(x,[595.0250498
  -4856.025050
   4078.329999
])
[x,fx,info,stats]=kinsol(fGPS,[0;0;6369],jacobian=jGPS)
x=kinsol(fGPS,[0;0;6369])
assert_checkalmostequal(x,[595.0250498
  -4856.025050
   4078.329999
])
x=kinsol(fGPS,[0;0;6369],display="iter")

// MATRIX EQUATION

function eq=f(X)
   eq = X*X*X - [1 2;3 4];
end
function eq=fC(X)
   eq = X*X*X - [1 2*%i;3 4];
end

X=kinsol(f,eye(2,2),tol=1e-8);
assert_checkalmostequal(X*X*X,[1 2;3 4])

[X,fX,info,out]=kinsol(fC,eye(2,2),tol=1e-12);
assert_checktrue(norm(fX) < 2e-15)
[X,fX,info,out]=kinsol(fC,eye(2,2),tol=1e-12,maxNewtonStep=1);
assert_checktrue(out.stats.nIters <= 20)

// 1D PDE
function eq = f(v,h)
  eq = ([0;v(1:$-1)] -2*v +[v(2:$);0])/h/h + 1./(1+v.^2-v.^3)
endfunction

N=100;
v0=zeros(N+1,1);
h=1/N;
[v,fv,info,s]=kinsol(f,v0,jacBand=[1 1]);

