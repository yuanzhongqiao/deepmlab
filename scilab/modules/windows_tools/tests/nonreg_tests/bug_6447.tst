// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 6447 -->
//
// <-- CLI SHELL MODE --> 
// <-- NO CHECK REF --> 
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/6447
//
// <-- Short Description -->
// unix_g() does not support properly neither UTF8 nor ANSI encoded output
// unix_g uses dos on Windows.

cd("SCI\modules\windows_tools\tests\nonreg_tests");

[stat, out] = host("type text_UTF8.txt");
ref = mgetl("text_UTF8.txt");
assert_checkequal(stat, 0);
assert_checkequal(out, ref);

[stat, out] = host("type text_ANSI.txt");
ref = mgetl("text_ANSI.txt");
assert_checkequal(stat, 0);
assert_checkequal(out, ref);
