// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- Non-regression test for bug 5375 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/5375
//
// <-- Short Description -->
// isdigit() doesn't support non ascii chars

//======================================================================================== 
ref = [%F %F %T];
res = isdigit("éa2");
if ~and(ref == res) then pause,end
//======================================================================================== 


