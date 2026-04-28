// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2017 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 12792 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12792
//
// <-- Short Description -->
//  save(filename, "undefinedVariable") created an empty useless file

fn = TMPDIR+"/bug_12792.dat";
try
    save(fn, "wxk8rt");
end
assert_checkfalse(isfile(fn));
