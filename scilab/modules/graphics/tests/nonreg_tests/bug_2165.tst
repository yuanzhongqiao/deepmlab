// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008-2008 - INRIA - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- NOT FIXED -->
// <-- TEST WITH GRAPHIC -->
// <-- ENGLISH IMPOSED -->

// <-- Non-regression test for bug 2165 -->
// <-- Non-regression test for bug 15410 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2165
// https://gitlab.com/scilab/scilab/-/issues/15410
//
// <-- Short Description -->
// Impossible to save Scilab variables when there are no more existing handles.

f = gcf();

delete(f);

warning("off");
if execstr("save(TMPDIR+""/bug_2165.tst"");", "errcatch")<>0 then pause; end
warning("on");
