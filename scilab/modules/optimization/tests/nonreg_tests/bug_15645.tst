// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- ENGLISH IMPOSED -->
//
// <-- Non-regression test for bug 15645 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15645
//
// <-- Short Description -->
// deff('y=f(x)','z=x^2'),fsolve(1,f) crashes scilab

deff('y=f1(x)','z=x^2'); 
deff('y=f2(x)','y=x^2'); 
deff('dy=df(x)','dz=2*x');
assert_checkerror("fsolve(1,f1)","Undefined variable ''y'' in function ''f1''.");
assert_checkerror("fsolve(1,f2,df)","Undefined variable ''dy'' in function ''df''.");
