// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2022 - UTC - Stéphane Mottelet
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

//HEAT EQUATION, BAND preconditionning and iterative linear solver
function [dv] = f_chaleur(t,v,h,lambda,c,rho,f)
  lambda_over_h2 = lambda/h/h;
  c_rho = c*rho;
  dv = (f+lambda_over_h2*( [0;v(1:$-1)] -2*v +[v(2:$);0] ))/c_rho;
endfunction

L=1; N=2000;
dx = L/N; x = linspace(dx,L-dx,N-1)';
lambda = 1;
c=200;
rho=7893;
d=0.02;
tf=300;
section=%pi*d^2/4;
rhoLin=rho*section;
f = x>1/4 & x<1/3;
v0=zeros(N-1,1);
tspan=0:1000// vecteur des temps

[ts,vs] = cvode(list(f_chaleur,dx,lambda,c,rhoLin,f),tspan,v0,linearSolver="CG",method="BDF",precBand=[1 1]);





