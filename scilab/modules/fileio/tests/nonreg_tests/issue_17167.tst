// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2024 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 17167 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17167
//
// <-- Short Description -->
// fullpath can miss trailing path separator

cd TMPDIR
mkdir existing_dir

assert_checkequal(fullpath("not_existing_dir\"), strcat([TMPDIR, "not_existing_dir", ""], filesep()));
assert_checkequal(fullpath("not_existing_dir/"), strcat([TMPDIR, "not_existing_dir", ""], filesep()));
assert_checkequal(fullpath("existing_dir\"),     strcat([TMPDIR, "existing_dir", ""], filesep()));
assert_checkequal(fullpath("existing_dir/"),     strcat([TMPDIR, "existing_dir", ""], filesep()));

