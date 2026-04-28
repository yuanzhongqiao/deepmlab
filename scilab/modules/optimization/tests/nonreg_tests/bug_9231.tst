// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 9231 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9231
//
// <-- Short Description -->
// fsolve() produces wrong info for certain initial values

function d = test(x)
   d = exp(x).*(3-x) - 3
endfunction
[x, v, info] = fsolve(2,test);
assert_checkequal(info,4);