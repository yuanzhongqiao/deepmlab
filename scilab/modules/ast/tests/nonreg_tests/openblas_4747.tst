// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for OpenBLAS #4747 -->
//
// <-- GitLab URL -->
// https://github.com/OpenMathLib/OpenBLAS/issues/4747
//
// <-- Short Description -->
// dgemm on HASWELL leads to invalid results

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// Should be exactly zero, the AVX2 code was less precise and generated %eps 
assert_checkequal([1, 2/3] * [-6 0 ; 9 0], [0 0])
