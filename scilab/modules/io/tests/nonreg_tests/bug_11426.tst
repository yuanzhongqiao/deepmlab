// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - Scilab Enterprises - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 11426 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/11426
//
// <-- Short Description -->
// Save function showed warning message in case of "save environment".

oldMode = warning("query");
warning("on");
save(TMPDIR + "/saveenv.dat");
warning(oldMode);
