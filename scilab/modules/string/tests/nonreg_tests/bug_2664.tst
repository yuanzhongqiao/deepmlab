// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Cong WU
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 2664 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2664
//
// <-- Short Description -->
//  strsubst() cannot be called in regexp mode
//

if execstr("strsubst(""2"",""/2(]*)?$\1/"",""0"",""r"")","errcatch") <> 0 then pause, end
