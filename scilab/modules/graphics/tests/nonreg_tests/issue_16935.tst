// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 16935 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16935
//
// <-- Short Description -->
// Variable is modified after a call to a graphics functions

a = [1.123, 6.5454, 9.54];
plot2d([0,1],[0,1],a);
assert_checkequal(a, [1.123, 6.5454, 9.54]);
