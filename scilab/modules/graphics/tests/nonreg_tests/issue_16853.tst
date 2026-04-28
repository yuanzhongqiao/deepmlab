// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

// <-- Non-regression test for issue 16853 -->
//
// <-- Bugzilla URL -->
// https://gitlab.com/scilab/scilab/-/issues/16853
//
// <-- Short Description -->
// plot(1:10, 'MarkerEdgeColor',[0.2 0.8 0.6]) yielded an error

assert_checkequal(execstr("plot(1:2, ""MarkerEdgeColor"",[0.2 0.8 0.6])", "errcatch"), 0);
assert_checkequal(execstr("plot(1:2, ""MarkBackground"",[0.2 0.8 0.6])", "errcatch"), 0);
assert_checkequal(execstr("plot(1:2, ""Foreground"",[0.2 0.8 0.6])", "errcatch"), 0);

