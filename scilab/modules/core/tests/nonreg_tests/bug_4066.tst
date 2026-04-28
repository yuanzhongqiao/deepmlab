// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2007-2009 - INRIA - Serge STEER <serge.steer@inria.fr>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 4066 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4066
//
// <-- Short Description -->
//    clear may erase protected variables
mputl('clear',TMPDIR+'/foo')
execstr("exec(TMPDIR+''/foo'')")
mdelete(TMPDIR+'/foo')
if exists('home')==0 then pause,end

