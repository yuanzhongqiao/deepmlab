// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 17466 -->
//
// <-- Bugzilla URL -->
// https://gitlab.com/scilab/scilab/-/issues/17466
//
// <-- Short Description -->
// Empty plot when giving a specific input

clf;plot([0 1],[40 40+1e-14])
xs2png(0,fullfile(TMPDIR,"bug_17466_1.png"))
clf;plot([0 1],[40 40])
xs2png(0,fullfile(TMPDIR,"bug_17466_2.png"))
res1 = getmd5(fullfile(TMPDIR,"bug_17466_1.png"))
res2 = getmd5(fullfile(TMPDIR,"bug_17466_2.png"))
assert_checkequal(res1,res2)
