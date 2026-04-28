// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - Digiteo - Jean-Baptiste Silvy
// Copyright (C) 2012 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->

// <-- Non-regression test for bug 4325 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4325
//
// <-- Short Description -->
// set("auto_clear","off") crashes Scilab.
// 

assert_checktrue(execstr("set(""auto_clear"",""off"")", "errcatch") == 0);
// should not crash Scilab.

assert_checktrue(execstr("set(""auto_clear"",""on"")", "errcatch") == 0);
assert_checktrue(get(gca(), "auto_clear") == "on");

assert_checktrue(execstr("set(""auto_clear"",""off"")", "errcatch") == 0);
assert_checktrue(get(gca(), "auto_clear") == "off");
