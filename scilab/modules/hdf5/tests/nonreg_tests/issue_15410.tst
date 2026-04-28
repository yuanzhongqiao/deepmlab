// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 15410 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15410
//
// <-- Short Description -->
// saving a closed figure crashes Scilab

f = gcf();
close();
fname = TMPDIR + filesep() + "issue_15410.sod";
msg = sprintf(_("%s: Unable to export variable ''%s'' in file ''%s''.\n"), "save", "f", fname);
assert_checkerror("save(fname, ""f"")", msg);
