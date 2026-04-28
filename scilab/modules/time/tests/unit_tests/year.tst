// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for year function
// =============================================================================

y = 2000:2025;
dt = datetime(string(y) + "-04-24");
assert_checkequal(year(dt), y);

dt = datetime(string(y)' + "-04-24");
assert_checkequal(year(dt), y');

ym = matrix(y, 13, 2);
dt = datetime(string(ym) +"-04-24");
assert_checkequal(year(dt), ym);

// check errors
msg = msprintf(_("%s: Wrong number of input argument(s): %d expected.\n"), "year", 1);
assert_checkerror("year()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "year", 1, sci2exp("datetime"));
assert_checkerror("year(1)", msg);
