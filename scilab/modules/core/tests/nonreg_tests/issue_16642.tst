// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 16642-->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16642
//
// <-- Short Description -->
// dollar fails when defining an empty variable: After x=[], x(1:$)=1 should leave x unchanged 
//

x=[]; x(1:0) = 1;
assert_checkequal(x, []);

x=[]; x(1:$) = 1;
assert_checkequal(x, []);
