//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 132 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/132
//
// <-- Short Description -->
//    bessely(0,1) produces convergence error


if execstr("bessely(0,1);", "errcatch")<>0 then pause,end

