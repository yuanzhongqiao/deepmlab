// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 14138 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14138
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Short Description -->
// reading some hdf5 file crashes scilab

h5=h5open("SCI/modules/hdf5/tests/nonreg_tests/issue_14138.h5");
eo=h5read(h5, 'error out');
assert_checkequal(eo.source, "");