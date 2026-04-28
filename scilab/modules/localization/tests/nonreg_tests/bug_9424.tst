// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
//<-- CLI SHELL MODE -->
//<-- NO CHECK REF -->
//
// <-- Non-regression test for bug 9424 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9424
//
// <-- Short Description -->
// gettext("") did not return ""

assert_checkequal(gettext(""), "");
assert_checkequal(gettext("scilab", ""), "");
assert_checkequal(gettext("mydomain", ""), "");
