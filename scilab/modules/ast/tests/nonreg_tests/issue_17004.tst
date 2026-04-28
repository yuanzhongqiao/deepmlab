// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17004-->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17004
//
// <-- Short Description -->
// after L = list(mode, lines), L(2)() yields a syntax error instead of running lines()
// 

L = list(mode, lines);

// checks that the function is extracted and called
assert_checkequal(L(2)(), lines());
