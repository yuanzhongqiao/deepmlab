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
// <-- Non-regression test for issue 16930 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16930
//
// <-- Short Description -->
// Wrong error management in loadmatfile

// Load variables from file
matfile = fullfile(SCI, "modules", "matio", "tests", "nonreg_tests", "t-circle.mat");

// Check error message in case of unknown option
assert_checkerror("loadmatfile(matfile, ""--toStruct"");", msprintf(gettext("%s: Unknown option: ''%s''.\n"), "loadmatfile", "--toStruct"));
assert_checkerror("loadmatfile(matfile, ""Potvac"", ""--toStruct"");", msprintf(gettext("%s: Unknown option: ''%s''.\n"), "loadmatfile", "--toStruct"));
assert_checkerror("loadmatfile(matfile, ""Potvac"", ""test"", ""--toStruct"");", msprintf(gettext("%s: Unknown option: ''%s''.\n"), "loadmatfile", "--toStruct"));

// Check error message if a variable is not found in the file
assert_checkerror("loadmatfile(matfile, ""Potvac"", ""test"", ""-toStruct"");", msprintf(gettext("%s: Variable ''%s'' was not found in file ''%s''.\n"), "loadmatfile", "test", matfile));

// Check error message when filename is not provided
assert_checkerror("loadmatfile(""-toStruct"");", msprintf(gettext("%s: No filename provided in input arguments.\n"), "loadmatfile"));
