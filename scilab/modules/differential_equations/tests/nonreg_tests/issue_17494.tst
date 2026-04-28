// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- NO CHECK REF -->
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for issue 17494 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17494
//
// <-- Short Description -->
// Arkode incorrect first step for Euler method

dt = 0.05;
tf = dt*3;
y0 = 20;

function dydt = odefun(t,y)
    dydt = -y;
endfunction

t1 = 0:dt:tf;
y1 = y0;
for ii=2:size(t1,"*")
y1(ii) = y1(ii-1) + dt*odefun(t1(ii-1), y1(ii-1));
end

[t2,y2] = arkode(odefun,[0 tf],y0,ERKButcherTab=[0 0;1 1],fixedStep=dt);

assert_checkequal(t1,t2);
assert_checkequal(y1,y2');
