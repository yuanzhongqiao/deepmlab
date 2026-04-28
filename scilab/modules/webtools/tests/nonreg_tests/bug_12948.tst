// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- Non-regression test for bug 12948 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12948
//
// <-- Short Description -->
// When host is not found, getURL provokes a Crash To Desktop

instr = "http_get(''https://www.scilab-dummy.org'', ''scilab_homepage.html'');";
errMsg = msprintf(_("%s: CURL execution failed.\n%s\n"), "http_get", "Could not resolve hostname");
assert_checkerror(instr, errMsg);
