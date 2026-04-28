//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 186 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/186
//
// <-- Short Description -->
//


a="100 100 z  ";
[values, ierr]= evstr(a);

if ierr==0 | ~isempty(values) then pause,end

a="100 100 m  ";
[values, ierr]= evstr(a);

if ierr==0 | ~isempty(values) then pause,end
