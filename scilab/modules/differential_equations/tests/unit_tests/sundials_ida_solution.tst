// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2021 - UTC - Stéphane Mottelet
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// y(t)=exp(-t)
function out = rexp(t,y,yp)
    out = y+yp;
end

// SIR MODEL
function res = sir(t,y,yp,bet,gam,N)
    res=[yp(1)+bet/N*y(1)*y(2)
         yp(2)-bet/N*y(1)*y(2)+gam*y(2)
         y(1)+y(2)+y(3)-N];
end
function jac = sir_jac(t,y,yp,c,bet,gam,N)
    jac = [ bet/N*y(2)+c  bet/N*y(1)       0
            -bet/N*y(2)   -bet/N*y(1)+gam+c 0
             1             1                1];
end

N=60e6;
gam=1/40;
bet=0.2;
y0=[N-1;1;0];

yp0 = [-bet/N*y0(1)*y0(2);+bet/N*y0(1)*y0(2)-gam*y0(2);gam*y0(2)];
sol = ida(list(sir,bet,gam,N),[0 100],y0,yp0,jacobian=list(sir_jac,bet,gam,N));
assert_checkalmostequal(sol(sol.t),sol.y)
sol2 = ida(sol,400);
assert_checkalmostequal(sol2(sol.t),sol.y)
assert_checkalmostequal(sol2(sol2.t),sol2.y)

sol = ida(rexp,[0 5],1,-1, rtol=1e-10, atol=1e-12, maxSteps=1000);
t = linspace(0,5,1000)
// test both outputs (y and its derivative)
[y,yp] = sol(t)
assert_checkalmostequal(exp(-t),y,1e-6,1e-8)
assert_checkalmostequal(-exp(-t),yp,1e-6,1e-8)
