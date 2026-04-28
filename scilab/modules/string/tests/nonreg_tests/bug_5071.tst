// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- Non-regression test for bug 5071 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/5071
//
// <-- Short Description -->
// isletter("é") returns [%F %F] instead of %F

//======================================================================================== 
v = "世界您好 3";
ref = [%T %T %T %T %F %F];
if ~and(isletter(v) == ref) then pause,end
if length(v) <> size(isletter(v),'*') then pause,end
//======================================================================================== 
v = "азеазея 3 азеазея";
ref = [ %T %T %T %T %T %T %T %F %F %F %T %T %T %T %T %T %T ];
if ~and(isletter(v) == ref) then pause,end
if length(v) <> size(isletter(v),'*') then pause,end
//======================================================================================== 
v = "TéTé a 3";
ref = [ %T %T %T %T %F %T %F %F ];
if ~and(isletter(v) == ref) then pause,end
if length(v) <> size(isletter(v),'*') then pause,end
//======================================================================================== 

