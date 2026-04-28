//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 3773 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3773
//
// <-- Short Description -->
// bug in predef "ans" was protected

ierr = execstr("predef(''a'');predef(''a'')","errcatch");
if ierr <> 0 then pause,end
