// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15525 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15525
//
// <-- Short Description -->
// memory allocation crash with a simple Scilab script
nx=256;
tau=-127:127;nt=size(tau,"*");
N=30;
x=complex(rand(nx,1),rand(nx,1));
af=zeros(N,nt); 
for i=1:nt
 taui=round(tau(i));
 t=(1+abs(taui)):(nx-abs(taui));
 af(t,i)=x(t+taui).* conj(x(t-taui));
end