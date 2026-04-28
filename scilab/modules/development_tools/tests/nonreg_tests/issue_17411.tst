// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- ENGLISH IMPOSED -->
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- TEST WITH ATOMS -->
//
// <-- Non-regression test for issue 17411 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17411
//
// <-- Short Description -->
// Executing toolbox tests on a "user" (eg. within SCIHOME) installation failed
//

exec("SCI/modules/atoms/tests/unit_tests/atomsTestUtils.sce");

atomsLoadTestScene("scene10");
atomsInstall("toolbox_5V6","user");
disp(atomsGetInstalled("all"))
disp(atomsAutoloadList())

assert_checktrue(test_run("toolbox_5V6"))
