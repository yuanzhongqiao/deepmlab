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
// <-- Non-regression test for issue 16324 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16324
//
// <-- Short Description -->
// mopen with option 'wt' crashes Scilab when file already exists.
//

testfile = TMPDIR + "filename.txt"

// Create file
fd = mopen(testfile, "w");
mclose(fd);

// Check that file exists
assert_checktrue(isfile(testfile));

// Non-regression test
fd = mopen(testfile, "wt");
mclose(fd);
