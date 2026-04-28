// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 17075 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17075
//
// <-- Short Description -->
// Crash related to complex matrix

// init variable
computed = 0;
// resize with 10% more
computed(20)=0;
// set complex then resize again
computed(30) = %i;

expected(30) = %i;
assert_checkequal(computed, expected);