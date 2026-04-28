// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 14701 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14701
//
// <-- Short Description -->
//  poly(c,v,'coeff') does not ignore null high order coefficient

p = poly([1 0 0],"x","coeff")
assert_checkequal(degree(p),0)