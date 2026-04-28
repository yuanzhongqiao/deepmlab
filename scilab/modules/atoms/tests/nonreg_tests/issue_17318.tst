// ============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Cedric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// ============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- Non-regression test for issue 17318 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17318
//
// <-- Short Description -->
// atomsInstall() does not work with a URL

try
    res = atomsInstall("file://"+SCI+"/modules/atoms/tests/unit_tests/toolbox_7V6_1.0-1.bin.zip");
    assert_checkequal(res(1), "toolbox_7V6");
    assert_checkequal(res(2), "1.0");
    assert_checkequal(res(3), "allusers");
    assert_checkequal(res(4), fullfile("SCI","contrib","toolbox_7V6","1.0"));
    assert_checkequal(res(5), "I");
    atomsRemove("toolbox_7V6");
catch
    atomsRemove("toolbox_7V6");
    error(lasterror());
end