// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for invhilb function
// =============================================================================

assert_checkequal(invhilb([]), []);

m = invhilb(1);
assert_checkequal(m, 1);

m = invhilb(2);
assert_checkequal(m, [4 -6; -6 12]);

m = invhilb(3);
expected = [9 -36 30; -36 192 -180; 30 -180 180];
assert_checkequal(m, expected);

// checkerror
msg = msprintf(_("%s: Wrong number of input argument(s): %d expected.\n"), "invhilb", 1);
assert_checkerror("invhilb()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "invhilb", 1, sci2exp("double"));
assert_checkerror("invhilb(""str"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be a scalar or empty.\n"), "invhilb", 1);
assert_checkerror("invhilb([1 2; 3 4])", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Non negative numbers expected.\n"), "invhilb", 1);
assert_checkerror("invhilb(-2)", msg);