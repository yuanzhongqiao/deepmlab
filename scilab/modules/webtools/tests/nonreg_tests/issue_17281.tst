// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Cédric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 17281 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17281
//
// <-- Short Description -->
// http_xxx() timeout

msg = msprintf(_("%s: CURL execution failed.\n%s\n"), "http_get", msprintf(_("Timeout was reached")));
assert_checkerror("http_get(""https://www.scilab.org"", timeout=0.001)", msg);