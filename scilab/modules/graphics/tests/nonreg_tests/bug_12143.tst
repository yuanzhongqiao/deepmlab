// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Charlotte HECQUET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 12143 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12143
//
// <-- Short Description -->
// "stop entity picker" (ged(11)) returns error 4

if getos() <> "Darwin"
    assert_checktrue(execstr("ged(11)", "errcatch") == 0);
end
close;
