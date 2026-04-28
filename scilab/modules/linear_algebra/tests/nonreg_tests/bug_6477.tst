// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 6477 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/6477
//
// <-- Short Description -->
// in some case, schur returned wrong values on Windows.

function [f] = z_choose(s,t)
  f = abs(s) > abs(t)
endfunction

a=[1 4 5 6; 3 2 5 7; 8 3 4 5; 9 3 5 2];
b=[3 8 5 7; 1 4 9 3; 9 1 0 7; 9 2 4 8];
[as, bs, z, dim] = schur(a, b, z_choose);

if dim <> 2 then pause, end

// check from the documentation :
// quasi triangular As matrix
assert_checkalmostequal(triu(as, -1), as);
// triangular Es matrix
assert_checkalmostequal(triu(bs), bs);
// stable "continuous time" generalized eigenspace
assert_checkalmostequal(abs(z*z'), eye(z), [], 1e-15);
