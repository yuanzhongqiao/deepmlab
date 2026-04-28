// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2026 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17526 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17526
//
// <-- Short Description -->
// Scilab fails when reading "DATASPACE SCALAR" attribute or dataset in HDF5 file.

// HDF5 file generated with Python 3.10.6:
//import h5py
//f = h5py.File("test_string.hdf5", "w")
//f.attrs["string_attr"] = "john"
//f["string_dataset"] = "doe"
//f.close()

f = fullfile(SCI, "modules", "hdf5", "tests", "nonreg_tests", "issue_17526.hdf5");

assert_checkequal(h5readattr(f, "/", "string_attr"), "john");

assert_checkequal(h5read(f, "/string_dataset"), "doe");
