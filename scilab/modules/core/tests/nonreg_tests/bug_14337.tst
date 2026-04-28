// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2015 - Scilab Enterprises - Cedric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 14337 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14337
//
// <-- Short Description -->
// piping one command using a shell pipepine ( "|" ) works, but scilab segfaults at exit

if getos() == "Windows"
    cmd = "echo (1 + 1) | " + WSCI + "\bin\scilex -ns ";
else
    cmd = "echo ""(1 + 1)"" | " + strsplit(SCI, "share/scilab")(1) + "/bin/scilab-cli -ns ";
end

[ierr, resp] = host(cmd)
assert_checkequal(ierr, 0);

expected = [
"";
"";
" ans = ";
"";
"   2.";
""
];

assert_checkequal(resp, expected);
