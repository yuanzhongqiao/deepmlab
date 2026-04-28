//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 5615 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/5615
//
// <-- Short Description -->
//  xls_open failed if there was a trailing space after the file extension
// 

xls_filename = SCI + '/modules/spreadsheet/demos/xls/Test1.xls';
ierr = execstr('[fd,SST,Sheetnames,Sheetpos] = xls_open(xls_filename);','errcatch');
if ierr <> 0 then pause,end
mclose(fd);

xls_filename = SCI + '/modules/spreadsheet/demos/xls/Test1.xls             ';
ierr = execstr('[fd,SST,Sheetnames,Sheetpos] = xls_open(xls_filename);','errcatch');
if ierr <> 0 then pause,end
mclose(fd);
