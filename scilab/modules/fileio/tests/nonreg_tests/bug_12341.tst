// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - Samuel GOUGEON
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 12341 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12341
//
// <-- Short Description -->
// rmdir() could delete a branch in which pwd() is

mkdir(TMPDIR+"/foo");
mkdir(TMPDIR+"/foo/bar");
cd(TMPDIR+"/foo/bar");
s = rmdir(TMPDIR+"/foo");
assert_checkequal(s, 0);
s = rmdir(TMPDIR+"/foo/bar");
if getos() == "Windows" then
    // Working directory cannot be removed
    assert_checkequal(s, 0);
    assert_checkequal(pwd(), fullfile(TMPDIR, "foo", "bar"));
else
    // Working directory can me removed, then pwd() is set to home()
    assert_checkequal(s, 1);
    assert_checkequal(pwd(), home());
end
    
