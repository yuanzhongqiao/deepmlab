// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 12956 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12956
//
// <-- Short Description -->
// url_split with no protocol in URL provokes an access violation exception
// originally splitURL
// No protocol

assert_checkerror("url_split(""www.scilab.org"")", [], 999);
