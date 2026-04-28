// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for day function
// =============================================================================

dt = datetime("2022-09-01");
assert_checkequal(day(dt), 1);
assert_checkequal(day(dt, "dayofmonth"), 1);
assert_checkequal(day(dt, "dayofyear"), 244);
assert_checkequal(day(dt, "dayofweek"), 5);
assert_checkequal(day(dt, "iso-dayofweek"), 4);
assert_checkequal(day(dt, "name"), "Thursday");
assert_checkequal(day(dt, "shortname"), "Thu");

dt = datetime(["10-Apr-2022" "20-Aug-2022"]);
assert_checkequal(day(dt), [10 20]);
assert_checkequal(day(dt, "dayofmonth"), [10 20]);
assert_checkequal(day(dt, "dayofyear"), [100 232]);
assert_checkequal(day(dt, "dayofweek"), [1 7]);
assert_checkequal(day(dt, "iso-dayofweek"), [7 6]);
assert_checkequal(day(dt, "name"), ["Sunday", "Saturday"]);
assert_checkequal(day(dt, "shortname"), ["Sun", "Sat"]);

dt = datetime([2022 10 1 9 53 30; 2022 12 31 23 59 59]);
assert_checkequal(day(dt), [1; 31]);
assert_checkequal(day(dt, "dayofmonth"), [1; 31]);
assert_checkequal(day(dt, "dayofyear"), [274; 365]);
assert_checkequal(day(dt, "dayofweek"), [7; 7]);
assert_checkequal(day(dt, "iso-dayofweek"), [6; 6]);
assert_checkequal(day(dt, "name"), ["Saturday"; "Saturday"]);
assert_checkequal(day(dt, "shortname"), ["Sat"; "Sat"]);

// with NaT
dt = NaT(2, 2);
dt(1,1) = datetime(2025, 1, 30);
dt(2,2) = datetime(2025, 5, 4);
assert_checkequal(day(dt), [30 %nan; %nan 4]);
assert_checkequal(day(dt, "dayofmonth"), [30 %nan; %nan 4]);
assert_checkequal(day(dt, "dayofyear"), [30 %nan; %nan 124]);
assert_checkequal(day(dt, "dayofweek"), [5 %nan;%nan 1]);
assert_checkequal(day(dt, "iso-dayofweek"), [4 %nan;%nan 7]);
assert_checkequal(day(dt, "name"), ["Thursday" ""; "" "Sunday"]);
assert_checkequal(day(dt, "shortname"), ["Thu" ""; "" "Sun"]);

// check errors
msg = msprintf(_("%s: Wrong number of input arguments: %d to %d expected.\n"), "day", 1, 2);
assert_checkerror("day()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "day", 1, sci2exp("datetime"));
assert_checkerror("day(1)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "day", 2, sci2exp("string"));
assert_checkerror("day(dt, 1)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Must be in %s.\n"), "day", 2, sci2exp(["dayofmonth", "dayofyear", "dayofweek", "iso-dayofweek", "name", "shortname"]));
assert_checkerror("day(dt, ""toto"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be a scalar.\n"), "day", 2);
assert_checkerror("day(dt, [""name"", ""name""])", msg);