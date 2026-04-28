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
// <-- Non-regression test for bug 17235 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17235
//
// <-- Short Description -->

assert_checktrue(execstr("tbx_build_help_loader(""toolbox title"", TMPDIR);", "errcatch") == 0);
assert_checktrue(isfile(fullfile(TMPDIR, "addchapter.sce")));