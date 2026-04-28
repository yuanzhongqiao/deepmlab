// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Cédric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 10898 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/10898
//
// <-- Short Description -->
// Introduce new tests for pipes

if getos() == "Windows" then
    sciCli = WSCI + "\bin\Scilex";
    sciAdvCli = WSCI + "\bin\WScilex-cli";
else
    sciCli = strsplit(SCI, "share/scilab")(1) + "/bin/scilab-cli";
    sciAdvCli = strsplit(SCI, "share/scilab")(1) + "/bin/scilab-adv-cli";
end

[ierr, resp] = host("echo %pi | "+sciCli+" -nb");
assert_checkequal(ierr, 0);
resp(find(resp=="")) = [];
[ierr, expected] = host(sciCli+" -nb -quit -e %pi");
assert_checkequal(ierr, 0);
expected(find(expected=="")) = [];
assert_checkequal(resp, expected);

[ierr, resp] = host("echo %pi | "+sciAdvCli+" -nb");
assert_checkequal(ierr, 0);
resp(find(resp=="")) = [];
[ierr, expected] = host(sciAdvCli+" -nb -quit -e %pi");
assert_checkequal(ierr, 0);
expected(find(expected=="")) = [];
assert_checkequal(resp, expected);

