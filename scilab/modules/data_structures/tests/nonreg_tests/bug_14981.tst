// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2017 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 14981 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14981
//
// <-- Short Description -->
// Some cells vertical concatenations and further cells extractions crash Scilab

// Should still be OK:
assert_checktrue(execstr("[{%f ; ""a""}  {%z ; %i}]", "errcatch")==0);

// Should now be OK:
assert_checktrue(execstr("[{%f  ""a""} ; {%z  %i}]", "errcatch")==0);
c = [{%f  "a"} ; {%z  %i}];
assert_checktrue(execstr("c{1,1}", "errcatch")==0);
c = [{%f  "a"} ; {%z  %i}];
assert_checktrue(execstr("c(1,1)", "errcatch")==0);
