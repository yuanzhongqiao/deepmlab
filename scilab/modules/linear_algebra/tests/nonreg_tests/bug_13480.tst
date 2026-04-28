// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug  -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13480
//
// <-- Short Description -->
// eigs(A) failed for full A with size(A,1)<8
//

for n = 3:9
    A = rand(n,n);
    assert_checktrue(execstr("eigs(A)", "errcatch")==0)
    assert_checktrue(execstr("eigs(A+A'')", "errcatch")==0)
    assert_checktrue(execstr("eigs(A+A*%i)", "errcatch")==0)
end
