// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for bug 9008 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9008
//
// <-- Short Description -->
// test_run() applied the create_ref option even on tests having the <-- NO CHECK REF --> header
//

test_run("polynomials", "bug_415", "create_ref"); //
// Bugged  :    001/001 - [polynomials] bug_415..............................passed: ref created
// Expected:    001/001 - [polynomials] bug_415..............................passed
