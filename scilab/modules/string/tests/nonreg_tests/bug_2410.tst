// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2007-2008 - INRIA - Pierre MARECHAL <pierre .marechal@inria.fr>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 2410 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2410
//
// <-- Short Description -->
//    string(boolean array) is incredibly slow

timer();
string(zeros(1,10000)==1);
a = timer()
if a > 0.1 then pause,end
