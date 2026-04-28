// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Pierre MARECHAL <pierre.marechal@inria.fr>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 2691 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2691
//
// <-- Short Description -->
//    bitand doesn't complain when it's called with only one argument.

if execstr("bitand(1);","errcatch") == 0 then pause,end
if execstr("bitor(1);" ,"errcatch") == 0 then pause,end
if execstr("bitxor(1);","errcatch") == 0 then pause,end
