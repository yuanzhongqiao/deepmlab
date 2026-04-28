// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - DIGITEO - Pierre MARECHAL <pierre.marechal@scilab.org>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 4311 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4311
//
// <-- Short Description -->
// rcond(eye()) returns eye() instead of 1.

if rcond(eye()) <> 1 then pause,end
