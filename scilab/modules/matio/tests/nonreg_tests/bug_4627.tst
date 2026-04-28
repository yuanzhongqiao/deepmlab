// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 4627 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4627
//
// <-- Short Description -->
//    The function matfile2sci does not manage 7.x format.

ierr = execstr("matfile2sci(""SCI/modules/matio/tests/nonreg_tests/bug_4627.mat"", ""TMPDIR/bug_4627.bin"");", "errcatch");
assert_checktrue(ierr==0);
ierr = execstr("load(""TMPDIR/bug_4627.bin"");", "errcatch");
assert_checktrue(ierr==0);
assert_checkequal(a, 10);
assert_checkequal(b, 20);
