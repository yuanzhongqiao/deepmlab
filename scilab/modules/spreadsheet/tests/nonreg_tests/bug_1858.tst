//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 1858 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/1858
//
// <-- Short Description -->
// 'readxls' is unusable on the two Windows XP 
// 

xls_filename = SCI + '/modules/spreadsheet/demos/xls/t1.xls';
for i = 1:100
  ierr = execstr('X = readxls(xls_filename);','errcatch');
  if ierr <> 0 then pause,end
end
