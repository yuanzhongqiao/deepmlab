// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2017 - ESI - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15188 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15188
//
// <-- Short Description -->
// hdf5_is_file failed to load

a = 1;
save("TMPDIR/file.sod", "a");
clear a;

assert_checktrue(hdf5_is_file("TMPDIR/file.sod"));
assert_checkfalse(hdf5_is_file("SCI/CHANGES.md"));

