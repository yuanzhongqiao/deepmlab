// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for wilkinson function
// =============================================================================

assert_checkequal(wilkinson([]), []);
assert_checkequal(wilkinson(0), []);

w = wilkinson(1);
assert_checkequal(w, 0);

w = wilkinson(2);
assert_checkequal(w, [0.5 1; 1 0.5]);

w = wilkinson(3);
expected = [1 1 0; 1 0 1; 0 1 1];
assert_checkequal(w, expected);

w = wilkinson(5);
expected = [2 1 0 0 0; 1 1 1 0 0; 0 1 0 1 0; 0 0 1 1 1; 0 0 0 1 2];
assert_checkequal(w, expected);

// checkerror
msg = msprintf(_("%s: Wrong number of input argument(s): %d expected.\n"), "wilkinson", 1);
assert_checkerror("wilkinson()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "wilkinson", 1, sci2exp("double"));
assert_checkerror("wilkinson(""str"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be a scalar or empty.\n"), "wilkinson", 1);
assert_checkerror("wilkinson([1 2; 3 4])", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Non negative numbers expected.\n"), "wilkinson", 1);
assert_checkerror("wilkinson(-2)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Integer numbers expected.\n"), "wilkinson", 1);
assert_checkerror("wilkinson(1.5)", msg);