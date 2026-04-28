// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- MACOSX ONLY -->//
// <-- Non-regression test for bug 15937 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15937
//
// <-- Short Description -->
// Unresolved TMPDIR makes mkdir fail on OSX
// bug #15937 is occuring for two levels or more:

path = fullfile(TMPDIR,"level1");
mkdir(path)
cd(path)

path2 = fullfile(TMPDIR,"level2","level3");
mkdir(path2)
cd(path2)