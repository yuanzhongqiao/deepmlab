// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2015 - Scilab Enterprises - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- ENGLISH IMPOSED -->
//
// <-- Non-regression test for bug 15106 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15106
//
// <-- Short Description -->
// Operation with null operand crashs Scilab


assert_checkerror("whereami() == ""SCI""", sprintf(_("Operation ''%s'': there is no left operand."),"=="));
assert_checkerror("""SCI"" == whereami()", sprintf(_("Operation ''%s'': there is no right operand."),"=="));
