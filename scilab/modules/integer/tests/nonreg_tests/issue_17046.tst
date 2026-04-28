// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2026 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// ===========================================================================
//
// <-- Non-regression test for issue 17046 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17046
//
// <-- Short Description -->
// mixed double + encoded integers arithmetic broked on macOS

assert_checkequal([-1 -1 -1] + uint8(127), uint8([126 126 126]));
assert_checkequal([-1 -1 -1 -1] + uint8(127), uint8([126 126 126 126]));

