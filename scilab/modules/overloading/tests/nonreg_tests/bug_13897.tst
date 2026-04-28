// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//<-- CLI SHELL MODE -->
//<-- NO CHECK REF -->
//
// <-- Non-regression test for bug 13897 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13897
//
// <-- Short Description -->
// 2 arrays of structures with same fields but in different order
//   could not be concatenated

p(1,1).a = %pi;
p(1,1).b = %z;
p(1,2).b = (1-%z)^2;

q.b = %s;
q.a = %e;

expected(1,1).a = %pi;
expected(1,1).b = %z;
expected(1,2).b = (1-%z)^2;
expected(1,3).b = %s;
expected(1,3).a = %e;

assert_checkequal([p q], expected);