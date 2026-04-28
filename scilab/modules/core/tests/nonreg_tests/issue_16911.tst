// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 16911 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Short Description -->
// Wrong line number in callstack

// test scrit
script=["[linn, mac] = where();", ...
        "assert_checkequal(linn, [1; 2; 50]);", ...
        "assert_checkequal(mac, [""exec""; ""issue_16911""; ""exec""]);"];

// create a script file
mputl(script, TMPDIR+"/issue_16911_script.sce");

// execute it
function issue_16911()
    exec(TMPDIR+"/issue_16911_script.sce");
end

issue_16911();
