// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - ESI Group - Clement DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//

//
// nominal check using a user-defined function
//
testFunctionFile = fullfile(SCI+"/modules/coverage/tests/unit_tests/testFunctions.sce");
exec(testFunctionFile);

profileEnable(coverageTest_foo)
// Executes the function
coverageTest_foo();

prof = profileGetInfo();
assert_checkequal(prof.FunctionTable.FunctionName, "coverageTest_foo");
assert_checkequal(size(prof.LineCoverage), 1);
assert_checkequal(prof.LineCoverage(1)(:,1), [-1;1;-1]);

//
// check with inner functions
//
profileEnable(coverageTest_with_inner)

// execute
coverageTest_with_inner()

prof = profileGetInfo();
assert_checkequal(prof.FunctionTable.FunctionName, ["coverageTest_foo" ; "coverageTest_with_inner" ; "coverageTest_inner"]);

//
// check API using Scilab functions
//

profileEnable(iscolumn) // from elementary_functionslib
// check that foo, with_inner, inner and iscolumn are instrumented
prof = profileGetInfo();
assert_checkequal(prof.FunctionTable.FunctionName, ["coverageTest_foo" ; "coverageTest_with_inner" ; "coverageTest_inner" ; "iscolumn"]);

profileEnable(corelib)
// check that at least publicly visible function are instrumented (inner functions are not visible)
assert_checktrue(size(profileGetInfo().LineCoverage) > 4 + size(libraryinfo("corelib"), "*"));

profileEnable()
// check that more than corelib and elementary_functionslib are instrumented
assert_checktrue(size(profileGetInfo().LineCoverage) > 4 + size(libraryinfo("corelib"), "*") + size(libraryinfo("elementary_functionslib"), "*"));

profileDisable()

//
// Check errors
//
errmsg = "profileEnable: Wrong type for input argument #1: A macro or library expected.";
assert_checkerror("execstr(""profileEnable(cos)"")", errmsg);

functionThatDoesNotExists = 42;
errmsg = "profileEnable: Wrong type for input argument #1: A macro or library expected.";
assert_checkerror("execstr(""profileEnable(functionThatDoesNotExists)"")", errmsg);
