// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 2389 -->
// <-- CLI SHELL MODE -->
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2389
//
// <-- Short Description -->
//   handle objects cannot be saved

A       = sparse(rand(5,5));
[h,rk]  = lufact(A);

// No possibility to save a pointer
if execstr("save(TMPDIR+""/pointer.bin"",""h"")", "errcatch")==0 then pause,end

ludel(h);
