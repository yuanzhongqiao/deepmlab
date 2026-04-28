// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for hankel function
// =============================================================================

// hankel(c)
h = hankel(1);
assert_checkequal(h, 1);

h = hankel([1 2]);
assert_checkequal(h, [1 2; 2 0]);

h = hankel([1; 2; 3]);
expected = [1 2 3; 2 3 0; 3 0 0];
assert_checkequal(h, expected);

h = hankel(1i);
assert_checkequal(h, 1i);

h = hankel([1 2] * 1i);
assert_checkequal(h, [1 2; 2 0] * 1i);

h = hankel([1; 2; 3] * 1i);
expected = [1 2 3; 2 3 0; 3 0 0] * 1i;
assert_checkequal(h, expected);

h = hankel(1 + 1i);
assert_checkequal(h, 1 + 1i);

h = hankel([1 2] + [1i 2i]);
assert_checkequal(h, [1 + 1i 2 + 2i; 2 + 2i 0]);

h = hankel([1; 2; 3] + [1i; 2i; 3i]);
expected = [1 2 3; 2 3 0; 3 0 0] + [1 2 3; 2 3 0; 3 0 0]*1i;
assert_checkequal(h, expected);

// hankel(c, r)
h = hankel([1,2], [2,7]);
assert_checkequal(h, [1 2; 2 7]);

h = hankel([1, 2, 3], [3,7]);
assert_checkequal(h, [1 2; 2 3; 3 7]);

h = hankel([1,2]*1i, [2,7]);
assert_checkequal(h, [1i 2i; 2i 7]);

h = hankel([1, 2, 3], [3,7]*1i);
assert_checkequal(h, [1 2; 2 3; 3 7*1i]);

// checkerror
msg = msprintf(_("%s: Wrong number of input arguments: %d to %d expected.\n"), "hankel", 1, 2);
assert_checkerror("hankel()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "hankel", 1, sci2exp("double"));
assert_checkerror("hankel(""str"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be a vector.\n"), "hankel", 1);
assert_checkerror("hankel([1 2; 3 4])", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "hankel", 2, sci2exp("double"));
assert_checkerror("hankel(1, ""str"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be a vector.\n"), "hankel", 2);
assert_checkerror("hankel(1, [1 2; 3 4])", msg);