// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2026 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 9985 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9985
//
// <-- Short Description -->
// lsqrsolve produced weird messages when f is complex

function y=f1(x, m)
  y=%i*(a*x+b)
endfunction
a=[1,7;
   2,8
   4 3];
b=[10;11;-1];
x0 = [100;100];
errmsg = msprintf("%s: Wrong type for output argument #%d: Real vector expected.\n", "f1", 1);
assert_checkerror("[xopt,fopt]=lsqrsolve(x0,f1,3);", errmsg);