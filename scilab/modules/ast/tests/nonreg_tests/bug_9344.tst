// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Bruno JOFRET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- ENGLISH IMPOSED -->
//
// <-- Non-regression test for bug 9344 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9344
//
// <-- Short Description -->
// Parser did not display anything when failing on UTF-8 char

errmsg = ["mclose(1";"^";"Error: 1.1->2.1 syntax error, unexpected end of line, expecting , or )"];
assert_checkerror("execstr(""mclose(1"")", errmsg);

errmsg = ["mclose(1°";"       ^~~^";"Error: 1.8->1.11 Can''t convert ''1°'' to a valid number nor identifier"];
assert_checkerror("execstr(""mclose(1°"")", errmsg);
