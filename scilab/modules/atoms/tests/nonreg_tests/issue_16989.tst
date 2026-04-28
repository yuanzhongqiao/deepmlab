// ============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// ============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for issue 16989 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16989
//
// <-- Short Description -->
// atomsSystemUpdate() can no more be run in -nwni mode.

assert_checkequal(getscilabmode(), "NWNI");

atomsSystemUpdate();
