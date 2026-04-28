// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - ESI Group - Clement DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16391 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16391
//
// <-- Short Description -->
// csvRead() crash with CSV files containing multiple empty lines

dataset = fullfile(TMPDIR,"bug_16391.csv");


fd = mopen(dataset, "w+");
mputl("# a comment", fd);
mputl("", fd);
mputl("0.0,0,1", fd);
mputl("", fd);
mputl("", fd);
mputl("", fd);
mputl("", fd);
mputl("", fd);
mclose(fd);

d = csvRead(dataset, ",", [],"double", [], "/#(.*)/" );
assert_checkequal(d, [0,0,1]);

