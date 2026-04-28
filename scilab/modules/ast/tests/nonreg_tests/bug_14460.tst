// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 14460 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14460
//
// <-- Short Description -->
// sparse boolean indices were not supported any more

s=speye(2,2);
assert_checkequal(s(s==1),sparse([1;1]) );
I=eye(2,2);
assert_checkequal(I(s==1),[1;1]);
k=(s==0);
s(k)=1;
assert_checkequal(s,sparse([1 1;1 1]));
I(k)=1;
assert_checkequal(I,[1 1;1 1]);


