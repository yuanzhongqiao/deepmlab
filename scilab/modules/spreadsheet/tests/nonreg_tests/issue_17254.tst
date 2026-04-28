// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17254 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17254
//
// <-- Short Description -->
// The "NumHeaderLines" option is now available in detectImportOptions function.

opts = detectImportOptions(fullfile(SCI, "modules", "spreadsheet", "tests", "nonreg_tests", "issue_17254.csv"), "NumHeaderLines", 2);

assert_checkequal(opts.variableNames, ["date", "values"]);
assert_checkequal(opts.delimiter, ";");
assert_checkequal(opts.decimal, ".");
assert_checkequal(size(opts.header), [2,1])
assert_checkequal(opts.header, ["aaa;bb bb;cccc;dd dd dd;ee eee";"ffffffff;gg g gg g;hhhhhh;iiii"]);