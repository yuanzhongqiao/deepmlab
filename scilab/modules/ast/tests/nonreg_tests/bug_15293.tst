// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15293 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15293
//
// <-- Short Description -->
// Scilab had troubles when comparing 2 lists L==L with void components.

l1 = list(1,,4)
l2 = list(1,,4)
assert_checktrue(l1 == l2)

l1 = list(,,4)
l2 = list(,,4)
assert_checktrue(l1 == l2)

l1 = list(1,,)
l2 = list(1,,)
assert_checktrue(l1 == l2)
