// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - Scilab Enterprises - Sylvestre Ledru
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 10396 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/10396
//
// <-- Short Description -->
// Display of a structure with large matrix took a long time.

a = struct();
a.toto = zeros(1,100000);
a.titi = zeros(1,100000);
timer();
a
timeSpent=timer()
assert_checktrue(timeSpent<1);
