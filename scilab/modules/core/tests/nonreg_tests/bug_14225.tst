// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2015 - Scilab Enterprises - Cedric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- NO CHECK ERROR OUTPUT -->
//
// <-- Non-regression test for bug 14225 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14225
//
// <-- Short Description -->
// 1. command-line option "-quit" should set the processs Exit status
// 2. piping to Scilab will exit without "-quit" and set the Exit status

//scilab path
if getos() == "Windows" then
    scilabBin = """" + WSCI + "\bin\scilex""";
else
    scilabBin = strsplit(SCI, "share/scilab")(1) + "/bin/scilab-cli";
end

// log isatty() output
disp(isatty());

// -quit is only discarded when standart input is redirected (piped mode)
if isatty() == %f then
    //With -quit argument
    err = host(scilabBin + " -e ""exit()"" -quit --timeout 2m");
    assert_checkequal(err, 0);
    err = host(scilabBin + " -e ""1+1;"" -quit --timeout 2m");
    assert_checkequal(err, 0);
    err = host(scilabBin + " -e ""1+1; exit(12)"" -quit --timeout 2m");
    assert_checkequal(err, 12);
    err = host(scilabBin + " -e ""error(\""error_test\"");"" -quit --timeout 2m");
    assert_checktrue(err <> 0 && err <> 22 && err <> 258);
    err = host(scilabBin + " -e ""error(\""error_test\"");exit(12)"" -quit --timeout 2m");
    assert_checktrue(err <> 12 && err <> 0 && err <> 22 && err <> 258);
    err = host(scilabBin + " -e ""try, error(\""error_test\""); catch, disp(lasterror()),end"" -quit --timeout 2m");
    assert_checkequal(err, 0);
    err = host(scilabBin + " -e ""try, error(\""error_test\""); catch,disp(lasterror());exit(12), end"" -quit --timeout 2m");
    assert_checkequal(err, 12);
end

//Without -quit argument
err = host(scilabBin + " -e ""exit()"" --timeout 2m");
assert_checkequal(err, 0);
err = host(scilabBin + " -e ""1+1; exit(12)"" --timeout 2m");
assert_checkequal(err, 12);
err = host(scilabBin + " -e ""try, error(\""error_test\""); catch,disp(lasterror());exit(12), end"" --timeout 2m");
assert_checkequal(err, 12);
