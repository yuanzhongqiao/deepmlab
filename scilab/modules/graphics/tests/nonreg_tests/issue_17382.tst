// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17382 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17382
//
// <-- Short Description -->
// subplot does not return the created/selected axes

a = subplot(1, 1, 1);
assert_checkequal(a, gca());
