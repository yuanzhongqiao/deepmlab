// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2021 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- Non-regression test for bug 16679 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16679
//
// <-- Short Description -->
// get_function_path("acosh") yielded an error (Scilab 6.0.0 regression)

// builtin
assert_checkequal(get_function_path("sin"), "<elementary_functions>");
// user macro
function test(), endfunction
assert_checkequal(get_function_path("test"), "<script>");
// macro in library
ref =  pathconvert("SCI\modules\elementary_functions\macros\sind.sci",%f,%t);
assert_checkequal(get_function_path("sind"), ref);

