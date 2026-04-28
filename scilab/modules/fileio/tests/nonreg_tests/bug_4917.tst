//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 4917 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4917
//
// <-- Short Description -->
//   fileinfo(SCI+'/') fails on windows

if fileinfo(SCI) <> fileinfo(SCI+'/') then pause,end
if fileinfo(SCI+'/') == [] then pause,end