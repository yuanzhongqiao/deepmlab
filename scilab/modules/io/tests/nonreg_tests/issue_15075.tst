// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- NO CHECK REF -->

// <-- Non-regression test for bug 15075 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15075
//
// <-- Short Description -->
// read: very slow with dims == -1

M = 5000000;
N = 5;

m = grand(M, N, "unf", 0, 10);
fprintfMat(TMPDIR + "\test_15075.txt", m);

timer();
data1 = read(TMPDIR + "\test_15075.txt", M, N);
time1 = timer()

timer();
data2 = read(TMPDIR + "\test_15075.txt", -1, N);
time2 = timer()

assert_checkequal(size(data1), size(data2));
assert_checkequal(data1, data2);
assert_checktrue(time2 <= time1 * 2);
