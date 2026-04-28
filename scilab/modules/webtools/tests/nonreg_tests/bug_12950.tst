// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - SCilab Enterprises
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- ENGLISH IMPOSED -->

// <-- Non-regression test for bug 12950 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12950
//
// <-- Short Description -->
// getURL ignores the proxy settings

atomsSaveConfig(%T);

atomsSetConfig("useProxy", "True");
atomsSetConfig("proxyHost", "123aa");

errMsg = msprintf(_("%s: CURL execution failed.\n%s\n"), "http_get", "Could not resolve proxy name");
try
    http_get("https://www.scilab.org", fullfile(TMPDIR,"scilab_homepage.html"));
catch
    error_msg = lasterror();
end

// Restore the config even if the test fails
atomsRestoreConfig();
assert_checkequal(error_msg, errMsg);

