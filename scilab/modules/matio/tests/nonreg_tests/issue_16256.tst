// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

//
// <-- Non-regression test for issue 16256 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16256
//
// <-- Short Description -->
// Extend loadmatfile to versions > 6. It presently trims the text value of a structure's field to its first character.

// File issue_16256.mat created by Octave 8.3.0 using:
// structS = struct('f1', 10, 'ftwo', 'Hello', 'field3', int8(12))
// save -mat7-binary issue_16256.mat structS

// Load variables from file
loadmatfile(fullfile(SCI, "modules", "matio", "tests", "nonreg_tests", "issue_16256.mat"));

// Check values
assert_checkequal(structS.ftwo, "Hello");
