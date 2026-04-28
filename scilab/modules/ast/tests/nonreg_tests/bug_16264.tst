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
// <-- Non-regression test for bug 16144 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16@^$
//
// <-- Short Description -->
// Unexpected iterator assigment in empty for loop

for k = 1:0;end
assert_checktrue(isempty(k))

