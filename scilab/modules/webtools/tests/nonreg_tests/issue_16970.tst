// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 16970 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16970
//
// <-- Short Description -->
// http_upload documentation example crashes Scilab

f1 = "myfilename";
f2 = "myfilenametwo";
data.type = "images";
data.date = date();

msg = msprintf(_("%s: Wrong type for input argument #%d: A string expected.\n"), "http_upload", 3, 1);
assert_checkerror("res = http_upload(""url:port/route"", [f1 f2], data, ""varname"");", msg);
