// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- Non-regression test for bug 13873 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13873
//
// <-- Short Description -->
// %hm_stdev(H,idim>2) returned zeros(H)

h = grand(2,3,2,"unf",-1,1);
assert_checktrue(and(stdev(h,3)~=zeros(h)));
