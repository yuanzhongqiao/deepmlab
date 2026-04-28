// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - ESI Group - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 16408 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16408
//
// <-- Short Description -->
//    toJSON(var, filename, indent) // cashes Scilab
// =============================================================================

assert_checktrue(execstr("toJSON([""a"" ""b""], tempname(), 1)", "errcatch") == 0);
assert_checktrue(execstr("toJSON([""a"" ""b""], 1, tempname())", "errcatch") == 0);
