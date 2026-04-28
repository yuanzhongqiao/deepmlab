// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - DIGITEO - Sylvestre LEDRU
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 426 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/426
//
// <-- Short Description -->
// Wrong permutation

a = ['aaa';'eee';'ccc';'bbb';'ddd';'rrr'];
trueValue=[1; 4; 3; 5; 2; 6];

[b result] = gsort(a,'r','i');
assert_checkequal(result, trueValue);
assert_checkequal(b, a([1 4 3 5 2 6]));
