// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 16278-->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16278
//
// <-- Short Description -->
// Recursive insertion on unknown function call crashes Scilab
//

foo().bar=1;
assert_checkequal(foo, struct("bar", 1));