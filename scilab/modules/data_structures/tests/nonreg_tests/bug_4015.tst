//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================


// <-- Non-regression test for bug 4015 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4015
//
// <-- Short Description -->
// "Flip left to right" x = x(:,$:-1:1,:) no longer works on hypermatrices.
// This used to work in version 4.

x=matrix(1:24,[2 3 4]);
ierr = execstr("x = x(:,$:-1:1,:);","errcatch");
if ierr<>0 then pause; end
                    
