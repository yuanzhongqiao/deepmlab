// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2017 - ESI - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 14901 -->
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14901
//
// <-- Short Description -->

if getos() == "Windows" then
    sciBin = WSCI + "\bin\scilex";
else
    sciBin = strsplit(SCI, "share/scilab")(1) + "/bin/scilab-cli";
end


txt = mgetl("SCI/modules/core/tests/nonreg_tests/bug_14901.java");
j = jcompile("Test_Exec_Scilab", txt);

f = fullfile(TMPDIR, "/scilab.out");
j.main(sciBin, f);

v = mgetl(f);
assert_checkequal(v, string(1:10)');

