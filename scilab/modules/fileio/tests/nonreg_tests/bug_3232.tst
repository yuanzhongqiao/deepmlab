// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 3232 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3232
//
// <-- Short Description -->
//mput ( 1 , 'plop' )
wm = warning('query');
warning('off');
ierr = execstr('mput ( 1 , ''plop'' );','errcatch');
warning(wm);
if ierr <> 10000 then pause,end
