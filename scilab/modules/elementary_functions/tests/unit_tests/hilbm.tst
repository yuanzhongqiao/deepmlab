// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for hilbm function
// =============================================================================

assert_checkequal(hilbm([]), []);

h = hilbm(1);
assert_checkequal(h, 1);

h = hilbm(2);
assert_checkequal(h, [1 1/2; 1/2 1/3]);

h = hilbm(3);
expected = [1 1/2 1/3; 1/2 1/3 1/4; 1/3 1/4 1/5];
assert_checkequal(h, expected);

// checkerror
msg = msprintf(_("%s: Wrong number of input argument(s): %d expected.\n"), "hilbm", 1);
assert_checkerror("hilbm()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "hilbm", 1, sci2exp("double"));
assert_checkerror("hilbm(""str"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be a scalar or empty.\n"), "hilbm", 1);
assert_checkerror("hilbm([1 2; 3 4])", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Non negative numbers expected.\n"), "hilbm", 1);
assert_checkerror("hilbm(-2)", msg);