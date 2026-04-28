// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Scilab Enterprises - Paul Bignier
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 7378 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7378
//
// <-- Short Description -->
// quart() failed when input argument only contained NaNs.
// =============================================================================

q1 = quart(%nan);
q2 = quart([%nan %nan]);
q3 = quart([%nan; %nan]);
q4 = quart(%nan, "r");
q5 = quart([%nan; %nan], "r");

assert_checkequal(q1, %nan);
assert_checkequal(q2, %nan);
assert_checkequal(q3, %nan);
assert_checkequal(q4, %nan);
assert_checkequal(q5, %nan);
