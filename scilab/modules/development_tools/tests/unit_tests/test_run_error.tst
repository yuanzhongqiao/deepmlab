// ============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// ============================================================================
//
// <-- NO CHECK REF -->
//
// test test_run with diferrent error cases.

tdir = TMPDIR+"/test_run_error";
mkdir(tdir);
mkdir(tdir+"/tests/unit_tests");

// assert functions
tmp = [
"// <-- Short Description -->"
"// essert check functions"
"// <-- CLI SHELL MODE -->"
"// <-- ENGLISH IMPOSED -->"
"// <-- NO ASSERT FAILURE -->"
""
"assert_checkequal(1,2)"
""
];
tfile = tdir+"/tests/unit_tests/test_run_error_0.tst";
xmlfile = tdir+"/test_run_error_0.xml";
mputl(tmp, tfile);
res = test_run(tdir, "test_run_error_0", [], xmlfile);
assert_checkfalse(res);

// Error on script execution
tmp = [
"// <-- Short Description -->"
"// Error in script execution"
"// <-- CLI SHELL MODE -->"
"// <-- ENGLISH IMPOSED -->"
""
"res = undefined/variable"
""
];
tfile = tdir+"/tests/unit_tests/test_run_error_1.tst";
xmlfile = tdir+"/test_run_error_1.xml";
mputl(tmp, tfile);
res = test_run(tdir, "test_run_error_1", [], xmlfile);
assert_checkfalse(res);
assert_checkfalse(grep(mgetl(xmlfile), "Undefined variable") == []);

// Parsing error
tmp = [
"// <-- Short Description -->"
"// Parsing error"
"// <-- CLI SHELL MODE -->"
"// <-- ENGLISH IMPOSED -->"
""
"parsing===error"
""
];
tfile = tdir+"/tests/unit_tests/test_run_error_2.tst";
xmlfile = tdir+"/test_run_error_2.xml";
mputl(tmp, tfile);
res = test_run(tdir, "test_run_error_2", [], xmlfile);
assert_checkfalse(res);
assert_checkfalse(grep(mgetl(xmlfile), "syntax error, unexpected") == []);

// then pause
test = [
"// <-- Short Description -->"
"// Parsing error"
"// <-- CLI SHELL MODE -->"
"// <-- ENGLISH IMPOSED -->"
""
"if(%t) then pause, end"
""
];
tfile = tdir+"/tests/unit_tests/test_run_error_3.tst";
mputl(test, tfile);

xmlfile = tdir+"/test_run_error_3.xml";
res = test_run(tdir, "test_run_error_3", [], xmlfile);
assert_checkfalse(res);
