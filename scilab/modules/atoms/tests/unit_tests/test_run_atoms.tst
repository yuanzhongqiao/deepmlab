// ============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2015 - Scilab Enterprises - John Gliksberg
//
//  This file is distributed under the same license as the Scilab package.
// ============================================================================

// <-- ENGLISH IMPOSED -->
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- TEST WITH ATOMS -->

exec("SCI/modules/atoms/tests/unit_tests/atomsTestUtils.sce");

// Load the 1st scenario : See scene10.test.atoms.scilab.org.txt
atomsLoadTestScene("scene10");

atomsInstall("toolbox_2V6");

atomsLoad("toolbox_2V6");

// Do the actual test_run
test_run("toolbox_2V6", "t2_function1", "short_summary");

atomsRemove("toolbox_2V6");
