// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for vander function
// =============================================================================

assert_checkequal(vander([]), []);

x = 1:3;
v = vander(x);
expected = [1 1 1; 1 2 4; 1 3 9];
assert_checkequal(v, expected);
assert_checkequal(v, vander(x'));

n = 5;
expected = [1 1 1 1 1; 1 2 4 8 16; 1 3 9 27 81];
assert_checkequal(vander(x, n), expected);

x = 0:0.5:2;
expected = [1 0 0 0 0; 
    1 0.5 0.25 0.125 0.0625;
    1 1 1 1 1;
    1 1.5 2.25 3.375 5.0625;
    1 2 4 8 16];
assert_checkequal(vander(x), expected);
assert_checkequal(vander(x), vander(x'));

v = [0:2]*%i;
expected = [1 0 0; 1 %i -1; 1 2*%i -4];
assert_checkequal(vander(v), expected);
assert_checkequal(vander(v), vander(v.'));

// checkerror
msg = msprintf(_("%s: Wrong number of input argument(s): %d to %d expected.\n"), "vander", 1, 2);
assert_checkerror("vander()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Real or complex vector expected.\n"), "vander", 1);
assert_checkerror("vander(""str"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: A vector expected.\n"), "vander", 1);
assert_checkerror("vander([1 2; 3 4])", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: A real scalar expected.\n"), "vander", 2);
assert_checkerror("vander(1, ""str"")", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: An integer value expected.\n"), "vander", 2);
assert_checkerror("vander(1, 1.5)", msg);
