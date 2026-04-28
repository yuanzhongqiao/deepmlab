// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- Non-regression test for bug 16038 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16038
//
// <-- Short Description -->
// cov(x,y) size checking of arguments is incorrect
// =============================================================================
//
x = rand(3,1);
y = rand(4,1);
message = msprintf(_("%s: Incompatible input arguments #%d and #%d: Same sizes expected.\n"),"cov",1,2);
assert_checkerror("cov(x,y)",message);
x = rand(3,3);
y = rand(4,4);
message = msprintf(_("%s: Incompatible input arguments #%d and #%d: Same number of rows expected.\n"),"cov",1,2);
assert_checkerror("cov(x,y)",message);
