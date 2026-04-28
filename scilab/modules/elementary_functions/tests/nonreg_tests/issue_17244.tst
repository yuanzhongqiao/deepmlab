// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17244 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17244
//
// <-- Short Description -->
// expm function returns totally wrong result for many negative values

assert_checkequal(expm(-100), exp(-100));

assert_checkequal(diag(expm(diag([-100 -200]))), diag(exp(diag([-100 -200]))));