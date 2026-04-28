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
// <-- Non-regression test for issue 8353 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8353
//
// <-- Short Description -->
// Just after launching scilab, 'log10(3)' makes Scilab crash.

assert_checkequal(log10(3), 0.47712125471966249);