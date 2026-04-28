// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2026 - Dassault Systèmes S.E. - Bruno JOFRET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 175511 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- ENGLISH IMPOSED -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17511
//
// <-- Short Description -->
// Parser state is puzzled after missing parenthesis error

errmsg = [  "max(";
            "^";
            "Error: 1.1->2.1 syntax error, unexpected end of line"];
assert_checkerror("execstr(""max("")", errmsg);

// Declare function foo after parse error.
assert_checkequal(exists("foo"), 0);
[ierr, errormsg] = execstr("function foo(); end", "errcatch")
assert_checkequal(errormsg, "");
assert_checkequal(exists("foo"), 1);
assert_checkequal(typeof(foo), "function");

