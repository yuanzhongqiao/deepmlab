// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2024 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 17312 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17312
//
// <-- Short Description -->
// Add raw format

filename = fullfile(TMPDIR, "issue_17312.md");
filearchive = filename + ".gz";
mputl("Issue 17312: Raw format file test", filename);

compress(filearchive, filename, format="raw", compression="gzip", level=0);
assert_checkequal(isfile(filearchive), %t);

mdelete(filename);
mdelete(filearchive);
