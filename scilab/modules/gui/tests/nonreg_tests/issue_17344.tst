// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->

// <-- Non-regression test for bug 17344 -->
//
// <-- Bugzilla URL -->
// https://gitlab.com/scilab/scilab/-/issues/17344
//
// <-- Short Description -->
// x_mdialog does not work with matrices since Scilab 2025.0.0

sz = [5 5];
default_input_matrix = "%"+string(rand(sz(1), sz(2)) > 0.5);
labelsv = string(1:sz(1));
labelsh = string(1:sz(2));
rep = x_mdialog("Enter a boolean matrix", labelsv, labelsh, default_input_matrix)

