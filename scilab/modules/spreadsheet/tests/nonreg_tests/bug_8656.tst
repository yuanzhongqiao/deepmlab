//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - S/E - Sylvestre Ledru
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// 
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 8656 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8656
//
// <-- Short Description -->
// Lost of precision
//
A = [1.01234567891234567,1.01234567891234567];
filename=fullfile(TMPDIR,'data.csv');
csvWrite(A,filename,",",".");
resString=mgetl(filename);
assert_checkequal(A,evstr(resString));

res=csvRead(filename);
assert_checkequal(A,res);

res=read_csv(filename);
assert_checkequal(evstr(res),A);
