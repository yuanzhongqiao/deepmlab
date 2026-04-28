// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- NO CHECK REF -->
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for issue 17287 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17287
//
// <-- Short Description -->
// sundials ode solvers fail to extend complex odes

function dydt = f(t,y,a)
   dydt = [0 1;-a 1]*y;
endfunction

function eq = res(t,y,yp,a)
   eq = yp-[0 1;-a 1]*y;
endfunction

a = 1+%i;
y0 = [1;0];

s = arkode(list(f,a),[0 2],y0);
s = arkode(s,4);

assert_checkalmostequal(s(2),s(2+2*%eps));

s = cvode(list(f,a),[0 2], y0);
s = cvode(s,4);

assert_checkalmostequal(s(2),s(2+2*%eps));

yp0 = [0 1;-a 1]*y0;
s = ida(list(res,a),[0 2],y0,yp0);
s = ida(s,4);

assert_checkalmostequal(s(2),s(2+2*%eps));
