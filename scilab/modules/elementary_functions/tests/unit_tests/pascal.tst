// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for pascal function
// =============================================================================

assert_checkequal(pascal([]), []);
assert_checkequal(pascal(0), []);

p = pascal(1);
assert_checkequal(p, 1);

p = pascal(2);
assert_checkequal(p, [1 1; 1 2]);

p = pascal(3);
expected = [1 1 1; 1 2 3; 1 3 6];
assert_checkequal(p, expected);

p5 = pascal(5);
expected = [1 1 1 1 1; 1 2 3 4 5; 1 3 6 10 15; 1 4 10 20 35; 1 5 15 35 70];
assert_checkequal(p5, expected);

p = pascal(2, 1);
assert_checkequal(p, [1 0; 1 -1]);
assert_checkequal(p^2, eye(2, 2));

p = pascal(3, 1);
expected = [1 0 0; 1 -1 0; 1 -2 1];
assert_checkequal(p, expected);
assert_checkequal(p^2, eye(3, 3));

p = pascal(5, 1);
assert_checkequal(p * p', p5);
assert_checkequal(p^2, eye(5, 5));

p = pascal(2, 2);
assert_checkequal(p, [-1 -1; 1 0]);
assert_checkequal(p^3, eye(2, 2));

p = pascal(3, 2);
expected = [1 1 1; -2 -1 0; 1 0 0];
assert_checkequal(p, expected);
assert_checkequal(p^3, eye(3, 3));

assert_checkequal(pascal(3,0), pascal(3));

// checkerror
msg = msprintf(_("%s: Wrong number of input arguments: %d to %d expected.\n"), "pascal", 1, 2);
assert_checkerror("pascal()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "pascal", 1, sci2exp("double"));
assert_checkerror("pascal(""str"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be a scalar or empty.\n"), "pascal", 1);
assert_checkerror("pascal([1 2; 3 4])", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Non negative numbers expected.\n"), "pascal", 1);
assert_checkerror("pascal(-2)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "pascal", 2, sci2exp("double"));
assert_checkerror("pascal(2, ""str"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be a scalar or empty.\n"), "pascal", 2);
assert_checkerror("pascal(2, [1 2])", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Must be in %s.\n"), "pascal", 2, sci2exp([0 1 2]));
assert_checkerror("pascal(2, 3)", msg);