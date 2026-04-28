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
// <-- Non-regression test for issue 17294 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17294
//
// <-- Short Description -->
// dae("root2",...) does not work as documented

// dy1/dt = y2
// dy2/dt = 100 * (1 - y1^2) * y2 - y1
// g = y1
t0 = 0;
y0 = [2;0];
y0d = [0; -2];
t = [20:20:200];
ng = 1;
rtol = [1.d-6; 1.d-6];
atol = [1.d-6; 1.d-4];

deff("[delta,ires]=res2(t,y,ydot)",...
"ires=0;y1=y(1),y2=y(2),delta=[ydot-[y2;100*(1-y1*y1)*y2-y1]]")

deff("s=gr2(t,y,yd)","s=yd(1)-1")

[yy, nn]=dae("root2", [y0, y0d], t0, t, rtol, atol, res2, ng, gr2);

assert_checkalmostequal(nn,[162.47037 1])
