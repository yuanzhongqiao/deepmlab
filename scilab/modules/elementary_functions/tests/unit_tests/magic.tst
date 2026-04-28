// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for magic function
// =============================================================================

assert_checkequal(magic([]), []);

m = magic(1);
assert_checkequal(m, 1);

m = magic(2);
assert_checkequal(m, [1 3; 4 2]);

m = magic(3);
expected = [8 1 6;3 5 7;4 9 2];
assert_checkequal(m, expected);

// checkerror
msg = msprintf(_("%s: Wrong number of input argument(s): %d expected.\n"), "magic", 1);
assert_checkerror("magic()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "magic", 1, sci2exp("double"));
assert_checkerror("magic(""str"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be a scalar or empty.\n"), "magic", 1);
assert_checkerror("magic([1 2; 3 4])", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Non negative numbers expected.\n"), "magic", 1);
assert_checkerror("magic(-2)", msg);