// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2022 - UTC - Stéphane Mottelet
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// DIFFUSION EQUATION, FINITE ELEMENTS

function [m,l]=matelem(r1,r2)
    // build elementary stiffness and mass matrix
    m = zeros(2,2);
    l = zeros(2,2);
    a = (r1+r2)/2;
    b = (r2-r1)/2;
    // Gauss points (3) and coefficients of integration formula
    xi = sqrt(3/5)*[-1 0 1];
    c = [5 8 5]/9;
    for i=1:length(xi)
        r  = a+b*xi(i);
        //mass
        v = [1-xi(i);1+xi(i)]/2;
        m = m + c(i)*b*v*v'*r*r;
        //laplacian with diffusion coefficient = 1 
        v = [-1;1]/2;
        l = l - c(i)/b*v*v'*r*r;
    end
endfunction

function [A,M,integ] = assembly(r)
    N=length(r);
    // assembly of stiffness, mass matrix and integration vector
    ij = zeros(4*(N-1),2);
    v = zeros(4*(N-1),1);
    w = zeros(4*(N-1),1);
    s = [0 0;1 0;0 1;1 1];
    k = 1;
    for i=1:N-1
        ij(k:k+3,:) = i+s;
        [m,l] = matelem(r(i),r(i+1));
        v(k:k+3) = l(:);
        w(k:k+3) = m(:);
        k = k+4;
    end
    M = sparse(ij,w,[N,N]);
    A = sparse(ij,v,[N,N]);
    integ = ones(1,N)*M;
end

function out=diffuse_res(t,u,up,tr1,tr2,alpha)
    // residual function for the system DAE
    out = A*u-M*up;
    alpha_t = alpha*(t<tr1 || t>tr2);
    out($)=out($)-alpha_t*u($);
endfunction

// // geometry
r = linspace(0,1,1000)';
// assembly of matrices
[A,M,integ] = assembly(r)

// Jacobian for computing initial velocity
J = A;
alpha = 100;
J($,$) = J($,$)-alpha;

// resolution of the DAE
tf = 0.5;
u0 = ones(r);
tr1 = 0.1;
tr2 = tr1+0.1;

[t,y1,info1] = ida(list(diffuse_res,tr1,tr2,alpha),[0 tf],u0,M\(J*u0),jacBand=[1 1]);
[t,y2,info2] = ida(list(diffuse_res,tr1,tr2,alpha),[0 tf],u0,M\(J*u0),jacPattern=A);

assert_checkalmostequal(y1,y2); 
assert_checkalmostequal(info1.stats.nRhsEvalsFD,info2.stats.nRhsEvalsFD); 





