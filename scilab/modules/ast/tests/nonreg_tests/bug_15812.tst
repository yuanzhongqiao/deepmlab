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
// <-- Non-regression test for bug 15812 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15812
//
// <-- Short Description -->
// On assigning variables the source variable becomes corrupted (e.g. x=[3 4 5];y(1,:)=x;)
u=[3 4 5];
clear v
v(1,:)=u;
assert_checkequal(size(u),[1,3])

