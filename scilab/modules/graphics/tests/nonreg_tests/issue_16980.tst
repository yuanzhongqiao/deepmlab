// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 16980 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16980
//
// <-- Short Description -->
// contour: fpf = ' ' does not turn off labels

x = linspace(-1, 1, 101);
z = x.' * x;
contour(x, x, z, 11, fpf = " ");

a = gca();
assert_checkequal(findobj(a.children(), "type", "Text"), []);
