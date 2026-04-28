// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for frank function
// =============================================================================

assert_checkequal(frank([]), []);

m = frank(1);
assert_checkequal(m, 1);

m = frank(2);
assert_checkequal(m, [2 1; 1 1]);

m = frank(3);
expected = [3 2 1; 2 2 1; 0 1 1];
assert_checkequal(m, expected);

// checkerror
msg = msprintf(_("%s: Wrong number of input argument(s): %d expected.\n"), "frank", 1);
assert_checkerror("frank()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "frank", 1, sci2exp("double"));
assert_checkerror("frank(""str"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be a scalar or empty.\n"), "frank", 1);
assert_checkerror("frank([1 2; 3 4])", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Non negative numbers expected.\n"), "frank", 1);
assert_checkerror("frank(-2)", msg);