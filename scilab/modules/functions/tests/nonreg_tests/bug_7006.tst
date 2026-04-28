// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for bug 7006 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7006
//
// <-- Short Description -->
// exec removed spaces at the end of filename when it returned an error.

scilab -f "blabla     "
exec("blabla     ")

// error must have blanks
//                    !--error 241 
//File "blabla     " does not exist or read access denied.
