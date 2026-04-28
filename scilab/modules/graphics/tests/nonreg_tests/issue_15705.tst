// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

// <-- Non-regression test for issue 15705 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15705
//
// <-- Short Description -->
// plot, plot2d: Crash when plotting values that are very close to each other

load("SCI/modules/graphics/tests/nonreg_tests/issue_15705.sod");
plot(i)
