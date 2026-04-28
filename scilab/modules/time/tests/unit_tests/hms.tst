// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for hms function
// =============================================================================

dt = datetime(2022, 6, 15, 12, 45, 30);
[h, m, s] = hms(dt);
assert_checkequal([h, m, s], [12, 45, 30]);

dt = datetime(2022, 6, 1:15, 12, 35:49, 30);
[h, m, s] = hms(dt);
assert_checkequal([h; m; s], [12*ones(1,15); 35:49; 30*ones(1,15)]);

dt = datetime([2025 1 29 1 25 30; 2025 1 29 3 43 12; 2025 1 29 15 24 46])';
[h, m, s] = hms(dt);
assert_checkequal([h; m; s], [1 3 15; 25 43 24; 30 12 46]);

d = duration(12, 45, 30);
[h, m, s] = hms(d);
assert_checkequal([h, m, s], [12, 45, 30]);

d = duration(12, 35:49, 30);
[h, m, s] = hms(d);
assert_checkequal([h; m; s], [12*ones(1,15); 35:49; 30*ones(1,15)]);

d = duration(12, 30, 45) + minutes(0:25:100);
[h, m, s] = hms(d);
assert_checkequal(h, [12 12 13 13 14]);
assert_checkequal(m, [30 55 20 45 10]);
assert_checkequal(s, 45 * ones(1, 5));

msg = msprintf(_("%s: Wrong number of input argument(s): %d expected.\n"), "hms", 1);
assert_checkerror("hms()", msg);
msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "hms", 1, sci2exp(["datetime", "duration"]));
assert_checkerror("hms(1)", msg);

