// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Bruno JOFRET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//

// Load test Function
testFunctionFile = fullfile(SCI+"/modules/coverage/tests/unit_tests/testFunctions.sce");
exec(testFunctionFile);

profileEnable(coverageTest_sleepStructure);
coverageTest_sleepStructure(%t, %f);
prof = profileGetInfo();
profileDisable();

assert_checkequal(prof.FunctionTable.FunctionName, "coverageTest_sleepStructure");
assert_checkequal(prof.FunctionTable.FirstLine, 25);
assert_checkequal(prof.FunctionTable.LastLine, 41);

instructionTime = prof.LineCoverage(1);
// sleep(200) - 200[ms]
assert_checkequal(instructionTime(2,1), 1);
assert_checktrue(instructionTime(2,2) >= 200e-3); // Check that sleep time was right
assert_checktrue(instructionTime(2,2) <= 250e-3); // Check that instruction was not run (or counted) more that once
// comment // some comment here
assert_checkequal(instructionTime(3,1), -1);
assert_checkequal(instructionTime(3,2), 0);
// sleep(500) - 500[ms]
assert_checkequal(instructionTime(4,1), 1);
assert_checktrue(instructionTime(4,2) >= 500e-3);
assert_checktrue(instructionTime(4,2) <= 550e-3);
