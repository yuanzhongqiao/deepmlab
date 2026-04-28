// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17293 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17293
//
// <-- Short Description -->
// datenum and datevec handle datetime type as input argument

assert_checkequal(datenum(datetime(2023, 14, 1)), 739283);
assert_checkequal(datenum(datetime(2023, [2; 14], 1)), [738918; 739283]);
dt = datetime([2024 8 19 12 10 00]);
assert_checkalmostequal(datenum(dt), 739483.506944444496);

d = datetime("10/3/2024", "InputFormat", "MM/dd/yyyy");
assert_checkequal(datevec(d), [2024 10 3 0 0 0]);
d = datetime("01.01.2024", "InputFormat", "dd.MM.yyyy");
assert_checkequal(datevec(d), [2024 1 1 0 0 0]);
d = datetime(["01.01.2024" "15.01.2024"; "15.12.2024", "31.12.2024"], "InputFormat", "dd.MM.yyyy");
assert_checkequal(datevec(d), [2024 1 1 0 0 0; 2024 12 15 0 0 0; 2024 1 15 0 0 0; 2024 12 31 0 0 0]);
d = datetime("01.01.2024 12:50:45", "InputFormat", "dd.MM.yyyy HH:mm:ss");
assert_checkalmostequal(datevec(d), [2024 1 1 12 50 45]);
d = datetime(["01.01.2024 13:12:06" "15.01.2024 12:58:09"; "15.12.2024 07:12:45", "31.12.2024 02:36:05"], "InputFormat", "dd.MM.yyyy HH:mm:ss");
assert_checkalmostequal(datevec(d), [2024 1 1 13 12 6; 2024 12 15 7 12 45; 2024 1 15 12 58 9; 2024 12 31 2 36 5]);

dt = datetime("01.01.2024", "InputFormat", "dd.MM.yyyy");
[y, m, d] = datevec(dt);
assert_checkequal(y, 2024);
assert_checkequal(m, 1);
assert_checkequal(d, 1);
dt = datetime(["01.01.2024" "15.01.2024"; "15.12.2024", "31.12.2024"], "InputFormat", "dd.MM.yyyy");
[y, m, d] = datevec(dt);
assert_checkequal(y, 2024 * ones(2, 2));
assert_checkequal(m, [1 1; 12 12]);
assert_checkequal(d, [1 15; 15 31]);
dt = datetime("01.01.2024 12:50:45", "InputFormat", "dd.MM.yyyy HH:mm:ss");
[y, m, d, h, mn, s] = datevec(dt);
assert_checkequal(y, 2024);
assert_checkequal(m, 1);
assert_checkequal(d, 1);
assert_checkequal(h, 12);
assert_checkequal(mn, 50);
assert_checkalmostequal(s, 45);