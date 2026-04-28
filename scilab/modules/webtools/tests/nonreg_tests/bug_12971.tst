// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- ENGLISH IMPOSED -->

// <-- Non-regression test for bug 12971 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12971
//
// <-- Short Description -->
// getURL() downloaded file name is wrong

filePath = http_get("www.scilab.org", fullfile(TMPDIR, "index.html"));

expectedFilePath = fullfile(TMPDIR, "index.html");
assert_checkequal(filePath, expectedFilePath);
assert_checktrue(isfile(filePath));

deletefile(filePath);
