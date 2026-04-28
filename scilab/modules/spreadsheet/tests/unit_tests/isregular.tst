// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Adeline CARNIS
// Copyright (C) 2022 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for isregular
// =============================================================================

d = hours(0:2:10);
assert_checktrue(isregular(d));

[x, s] = isregular(d);
assert_checktrue(s == hours(2));

d = hours(rand(1,10) * 10);
[x, s] = isregular(d);
assert_checkfalse(x);
assert_checkequal(s, %nan);

d = gsort(datetime(floor(2000 * rand(1,100)), floor(12 * rand(1,100)+1), floor(30 * rand(1,100)+1)));
[x, s] = isregular(d);
assert_checkfalse(x);
assert_checkequal(s, %nan);

d = datetime(2000, 1, 1): calmonths(2): datetime(2001, 1, 1);
[x, s] = isregular(d);
assert_checkfalse(x);
assert_checkequal(s, %nan);

[x, s] = isregular(d, "months");
assert_checktrue(x);
assert_checktrue(s == calmonths(2));

d = datetime(2000, 1, 1): caldays(15): datetime(2000, 3, 1);
[x, s] = isregular(d);
assert_checktrue(x);
assert_checktrue(s == days(15));

Time = duration(0,0:10, 0)';
Temperature = [38 37.5 37.4 37.5 37.1 37.6 37.7 38.2 37.8 37 38.3]';
ts = timeseries(Time, Temperature, "VariableNames", ["Time", "Temp"]);
[x, s] = isregular(ts);
assert_checktrue(x);
assert_checktrue(s == minutes(1));

// errors
msg = msprintf(_("%s: Wrong number of input argument: %d to %d expected.\n"), "isregular", 1, 2);
assert_checkerror("isregular()", msg);
assert_checkerror("isregular(hours(2), ""time"", 1)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: duration, datetime or timeseries expected.\n"), "isregular", 1);
assert_checkerror("isregular(1)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: string expected.\n"), "isregular", 2);
assert_checkerror("isregular(hours(2), 1)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: {""%s"", ""%s"", ""%s"", ""%s""} expected.\n"), "isregular", 2, "years", "months", "days", "time");
assert_checkerror("isregular(hours(2), ""toto"")", msg);
