// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

// <-- Non-regression test for issue 16785 -->
//
// <-- Bugzilla URL -->
// https://gitlab.com/scilab/scilab/-/issues/16785
//
// <-- Short Description -->
// xsave/save of datatips produced double free in data model

load("SCI/modules/graphics/tests/nonreg_tests/issue_16785_552.sod");
f = gcf();
xsave(fullfile(TMPDIR, "issue_16785.sod"), f.figure_id);
close(f.figure_id);
