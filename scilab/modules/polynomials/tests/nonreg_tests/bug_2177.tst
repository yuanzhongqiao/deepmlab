// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 2177 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2177
//
// <-- Short Description -->
// When i calculate roots of a simple matrix 2X2, using function ROOTS, Scilab crashes.

A=[1,2;3,4];
S=poly(A,"x");
[y]=roots(S);


