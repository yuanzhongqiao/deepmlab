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
// <-- Non-regression test for bug 16014 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16014
//
// <-- Short Description -->
// After x.a=1; x(:)=[], x.a is an empty list

x.a = 1;
x(:) = [];
assert_checktrue(isstruct(x));
assert_checktrue(isempty(x));

