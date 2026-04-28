// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for month function
// =============================================================================

dt = datetime("2022-09-01");
assert_checkequal(month(dt), 9);
assert_checkequal(month(dt, "monthofyear"), 9);
assert_checkequal(month(dt, "name"), "September");
assert_checkequal(month(dt, "shortname"), "Sep");

dt = datetime(["10-Apr-2022" "20-Aug-2022"]);
assert_checkequal(month(dt), [4 8]);
assert_checkequal(month(dt, "monthofyear"), [4 8]);
assert_checkequal(month(dt, "name"), ["April", "August"]);
assert_checkequal(month(dt, "shortname"), ["Apr", "Aug"]);

dt = datetime([2022 10 1 9 53 30; 2022 12 31 23 59 59]);
assert_checkequal(month(dt), [10; 12]);
assert_checkequal(month(dt, "monthofyear"), [10; 12]);
assert_checkequal(month(dt, "name"), ["October"; "December"]);
assert_checkequal(month(dt, "shortname"), ["Oct"; "Dec"]);

// with NaT
dt = NaT(2, 2);
dt(1,1) = datetime(2025, 1, 30);
dt(2,2) = datetime(2025, 5, 4);
assert_checkequal(month(dt), [1 %nan; %nan 5]);
assert_checkequal(month(dt, "monthofyear"), [1 %nan; %nan 5]);
assert_checkequal(month(dt, "name"), ["January" "";"" "May"]);
assert_checkequal(month(dt, "shortname"), ["Jan" "";"" "May"]);

// check errors
msg = msprintf(_("%s: Wrong number of input arguments: %d to %d expected.\n"), "month", 1, 2);
assert_checkerror("month()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "month", 1, sci2exp("datetime"));
assert_checkerror("month(1)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "month", 2, sci2exp("string"));
assert_checkerror("month(dt, 1)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Must be in %s.\n"), "month", 2, sci2exp(["monthofyear", "name", "shortname"]));
assert_checkerror("month(dt, ""toto"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be a scalar.\n"), "month", 2);
assert_checkerror("month(dt, [""name"", ""name""])", msg);