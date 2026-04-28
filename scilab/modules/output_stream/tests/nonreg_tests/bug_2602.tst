// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Pierre MARECHAL <pierre.marechal@inria.fr>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 2602 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2602
//
// <-- Short Description -->
//    printf('%%') display a blank character instead of the percent character

if sprintf("%%")<>"%" then pause,end
if msprintf("%%")<>"%" then pause,end
