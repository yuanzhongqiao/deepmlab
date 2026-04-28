// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- NO CHECK REF -->
// <-- TEST WITH GRAPHIC -->
//
// <-- Non-regression test for issue 16070 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16070
//
// <-- Short Description -->
// feval(0:3,string) => error message in Chinese: 敦慶l: An error occurred in '硥捥敆慶䙬' subroutine.

// 1 - Basic test case with feval()
execstr("feval(0:3,string)", "errcatch");
errmsg = lasterror();
assert_checktrue(strindex(errmsg(2), "feval:") <> []);
assert_checktrue(strindex(errmsg(2), "''execFevalF''") <> []);

// 2 - Same issue for Sfgrayplot calling feval() (based on https://help.scilab.org/Sfgrayplot)
function z=surf1(x, y)
    z=[x*y x*y]; // Wrong size => error
endfunction

x = linspace(-1,1,60);
y = linspace(-1,1,60);
execstr("Sfgrayplot(x,y,surf1);", "errcatch");
errmsg = lasterror();
assert_checktrue(strindex(errmsg(2), "feval:") <> []);
assert_checktrue(strindex(errmsg(2), "''execFevalF''") <> []);
