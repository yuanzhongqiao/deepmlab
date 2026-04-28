// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15668 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15668
//
// <-- Short Description -->
// save(filename) saves all predefined Scilab constants %e %pi etc.. (regression)


clear
x=1;
save(fullfile(TMPDIR,"session.sod"));
assert_checkequal(listvarinfile(fullfile(TMPDIR,"session.sod")),"x")