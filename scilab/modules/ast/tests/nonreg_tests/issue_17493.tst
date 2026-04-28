// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 17493 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17493
//
// <-- Short Description -->
// Inserting empty matrix in last index of empty matrix crashes Scilab

errmsg = msprintf(_("Submatrix incorrectly defined.\n"));
assert_checkerror("a = []; a($) = [];", errmsg);
