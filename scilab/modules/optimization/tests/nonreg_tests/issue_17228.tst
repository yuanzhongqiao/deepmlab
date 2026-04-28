// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17228 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17228
//
// <-- Short Description -->
// qld raises error despite third output argument given
//

Q=zeros(2,2);
p=[1;1];
b=-[1;1];
C=eye(2,2);
ci=[0;0];
cs=[];
me=2;
[x ,lagr ,info] = qld(Q, p, C, b, ci, cs, me);
assert_checkequal(info,10)
