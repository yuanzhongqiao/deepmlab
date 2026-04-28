// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 17460 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17460
//
// <-- Short Description -->
// Reading json file with empty objects

expected = struct("ingredient_names",list([],[]));
assert_checkequal(expected, fromJSON(toJSON(expected)));

json_file = fullfile(TMPDIR, "issue_17460.json");
toJSON(expected, json_file);
assert_checkequal(expected, fromJSON(json_file, "file"));
