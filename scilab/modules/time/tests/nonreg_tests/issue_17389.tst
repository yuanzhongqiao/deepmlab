// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17389 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17389
//
// <-- Short Description -->
// datetime input format crashed when dealing with milliseconds field > 0 while 
// seconds field is 59

dt = datetime("2022-12-25 15:54:01.456", "InputFormat", "yyyy-MM-dd HH:mm:ss.SSS");
assert_checkequal(string(dt), "2022-12-25 15:54:01.456");

dt = datetime("2018-07-10 14:30:59.100", "InputFormat", "yyyy-MM-dd HH:mm:ss.SSS");
assert_checkequal(string(dt), "2018-07-10 14:30:59.100");

dt = datetime("2018-07-10 15:54:01.456", "InputFormat", "yyyy-MM-dd HH:mm:ss.SSS");
assert_checkequal(string(dt), "2018-07-10 15:54:01.456");

dt = datetime("2018-07-10 14:30:01.456", "InputFormat", "yyyy-MM-dd HH:mm:ss.SSS");
assert_checkequal(string(dt), "2018-07-10 14:30:01.456");

dt = datetime("2018-07-10 14:30:59.456", "InputFormat", "yyyy-MM-dd HH:mm:ss.SSS");
assert_checkequal(string(dt), "2018-07-10 14:30:59.456");

dt = datetime("2018-07-10 14:30:59.000", "InputFormat", "yyyy-MM-dd HH:mm:ss.SSS");
assert_checkequal(string(dt), "2018-07-10 14:30:59");