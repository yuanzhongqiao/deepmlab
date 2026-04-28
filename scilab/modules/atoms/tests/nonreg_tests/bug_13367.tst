// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2014 - Scilab Enterprises - Bruno JOFRET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH ATOMS -->
// <-- NO CHECK REF -->
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 13367 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13367
//
// <-- Short Description -->
// Wrong atoms default repository

defaultRepo = atomsRepositoryList()
v = getversion("scilab")

goodRepo = sprintf("https://atoms.scilab.org/%d.%d/TOOLBOXES/64", v(1), v(2));

assert_checkequal(defaultRepo(1), goodRepo);
