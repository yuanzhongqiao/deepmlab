// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- ENGLISH IMPOSED -->
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for issue 11983 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/11983
//
// <-- Short Description -->
// getAllocatedSingleString produces wrong error messages.

ilib_verbose(0);

testdir = fullfile(TMPDIR, "issue_11983");
mkdir(testdir);
cd(testdir);

copyfile(fullfile(SCI, "modules", "api_scilab", "tests", "nonreg_tests", "issue_11983.c"), fullfile(testdir, "issue_11983.c"));

ilib_build("gw_issue_11983", ["issue_11983", "sci_issue_11983"], "issue_11983.c", []);
exec("loader.sce");

issue_11983(2);
