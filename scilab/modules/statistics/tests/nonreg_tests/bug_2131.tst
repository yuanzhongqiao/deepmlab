//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2005-2008 - INRIA -Pierre MARECHAL <pierre.marechal@inria.fr>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 2131 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2131
//
// <-- Short Description -->
//Inconsistent results from functions median() with given argument of [].

if ~isnan(median([])) then pause,end
if ~isempty(median([],1)) then pause,end
if ~isempty(median([],2)) then pause,end
