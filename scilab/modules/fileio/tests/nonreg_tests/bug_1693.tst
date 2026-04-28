// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2005-2008 - INRIA - Pierre MARECHAL <pierre.marechal@inria.fr>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 1693 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/1693
//
// <-- Short Description -->
//    cd \ throws an error
// ...

// ================== Test 1 ==================

cd('\');

if getos() == 'Windows' 
	assert_checktrue(or(getdrives() == pwd()));
else
	assert_checkequal(pwd(), '/');
end

// ================== Test 2 ==================

cd home;
assert_checkequal(pwd(), home);

// ================== Test 3 ==================

if getos() == 'Windows' then
	cd WSCI;
	assert_checkequal(pwd(), WSCI);
end

// ================== Test 4 ==================

cd SCIHOME;
assert_checkequal(pwd(), fullpath(SCIHOME)); // fullpath needed in case -scihome parameter is used at Scilab startup and contains relative paths (cf CI)

// ================== Test 5 ==================

cd SCIHOME;
assert_checkequal(pwd(), fullpath(SCIHOME)); // fullpath needed in case -scihome parameter is used at Scilab startup and contains relative paths (cf CI)

// ================== Test 6 ==================

cd PWD;
assert_checkequal(pwd(), PWD);
