// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 16823 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16823
//
// <-- Short Description -->
// Mtbxfun_db.txt file was missing in releases.

assert_checktrue(isfile(fullfile(SCI, "modules", "m2sci", "Mtbxfun_db.txt")));
