// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17441 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17441
//
// <-- Short Description -->
// using save() with spécial characters in filename leads to wrong file name.

filename = fullfile(TMPDIR, "éé.sod");
save(filename, "filename");
assert_checkequal(ls(filename), filename);