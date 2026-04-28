// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Clément DAVID
// Copyright (C) 2022 - ESI Group - Clement DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 16196 -->
//
// <-- ENGLISH IMPOSED -->
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Bugzilla URL -->
// https://gitlab.com/scilab/scilab/-/issues/16196
//
// <-- Short Description -->
// covStart() did not check incorrect arguments

assert_checkerror("covStart(""invalid Scilab module name"")", "covStart: Wrong input argument #1: this is not a Scilab module with macros.");
assert_checkerror("covStart([""invalid Scilab module name"" ""getscilabkeywords""])", "covStart: Wrong input argument #1: this is not a Scilab module and associated macros.");
assert_checkerror("covStart([""core"" ""getscilabkeywords_foobar""])", "covStart: Wrong input argument #1: this is not a Scilab module and associated macros.");

// valid calls
info1 = covStart(["SCI/modules/core/macros" "getscilabkeywords"])
assert_checktrue(info1 > 0);

info2 = covStart(["corelib" "getscilabkeywords"])
assert_checktrue(info2 > 0);

assert_checkequal(info1, info2);
