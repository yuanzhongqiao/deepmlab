// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 17175 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//<-- NO CHECK ERROR OUTPUT -->

// <-- Short Description -->
// bin/scilab exit code is incorrect on syntax error.

//scilab path
if getos() == "Windows" then
    scilabBin = """" + WSCI + "\bin\scilex""";
else
    scilabBin = strsplit(SCI, "share/scilab")(1) + "/bin/scilab-cli";
end

err = host(scilabBin + " -e ""1+"" -quit --timeout 2m");
assert_checktrue(err <> 0);
