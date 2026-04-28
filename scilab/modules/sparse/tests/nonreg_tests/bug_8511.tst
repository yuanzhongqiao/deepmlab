// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Charlotte HECQUET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 8511 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8511
//
// <-- Short Description -->
// sprand uses rand and grand functions, and internal state of the random number
// generator is changed

grand("setsd",0);
state1=rand("seed");
A = sprand(5,5,.05);
state2=rand("seed");
assert_checkequal(state1,state2);
