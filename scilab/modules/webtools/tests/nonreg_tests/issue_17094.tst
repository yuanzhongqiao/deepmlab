// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 17094 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17094
//
// <-- Short Description -->
// fromJSON: avoid parsing all data to know if its in JSON format.

path = get_absolute_file_path();
try, timer();fromJSON(path+"issue_17094.txt", "file"); catch, t=timer() end

// check the function hasn't parsed all data
// before returning that data is not a JSON format.
assert_checktrue(t < 1);
