// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 13936 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13936
//
// <-- Short Description -->
// The exponentiation of a matrix was very slow



k = 10;
M = rand(1000,1000);

timer()
pM1 = M^k;
t1 = timer()

timer()
pM2 = eye(M);
for i = 1:k
    pM2 = M*pM2;
end
t2 = timer()

assert_checktrue(t2>t1);
