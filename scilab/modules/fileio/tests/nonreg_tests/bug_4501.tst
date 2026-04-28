// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) DIGITEO - 2009 - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 4501 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4501
//
// <-- Short Description -->
//  mput() no more allowed integer types as first input argument.

u = mopen(TMPDIR+'/foo','wb');
ierr = execstr('mput(int32(1996),''l'',u);','errcatch');
if ierr <> 0 then pause,end


