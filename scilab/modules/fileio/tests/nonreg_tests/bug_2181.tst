// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2006-2008 - INRIA - Pierre MARECHAL <pierre.marechal@inria.fr>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
//<-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 2181 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2181
//
// <-- Short Description -->
//    getrelativefilename crashes when the two arguments it receives refer to 
//    different drives.
//
//    Francois

if getos() == 'Windows' then
	
	test1 = getrelativefilename("D:\","C:\Program Files\scilab\readme.txt");
	test2 = getrelativefilename("C:\","C:\Program Files\scilab\readme.txt");
	test3 = getrelativefilename("C:\Documents and Settings","C:\Program Files\scilab\readme.txt");
	test4 = getrelativefilename("C:\PROGRAM FILES\toto","c:\program files\scilab\readme.txt");

	assert_checkequal(test1, "C:\Program Files\scilab\readme.txt");
	assert_checkequal(test2, "Program Files\scilab\readme.txt");
	assert_checkequal(test3, "..\Program Files\scilab\readme.txt");
	assert_checkequal(test4, "..\scilab\readme.txt");
	
end
