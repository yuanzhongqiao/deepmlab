// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15964 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15964
//
// <-- Short Description -->
// The complex empty sparse matrix must resume to the real one.

s = sprand(10,10,0.3)*%i;
s(:)=[];
assert_checktrue(issparse(s))
assert_checktrue(isreal(s))
s = sprand(1,10,0.3)*%i;
s(1,:)=[];
assert_checktrue(issparse(s))
assert_checktrue(isreal(s))
