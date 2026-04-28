// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- NO CHECK REF -->
// <-- Non-regression test for issue 17211 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17211
//
// <-- Short Description -->
// int2d returns an error when called with 6 input arguments.

deff("z=f(x,y)", "z=cos(x+y)");
[I,e] = int2d(0,1,0,1,f,[1.d-10, 1, 50, 4000, 1]);

