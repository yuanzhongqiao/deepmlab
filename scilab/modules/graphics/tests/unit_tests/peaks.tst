// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

msg = msprintf(_("Wrong number of input arguments.\n"));
assert_checkerror("peaks(0, 1, 2)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in ""double"".\n"), "peaks", 1);
assert_checkerror("peaks(""a"")", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Real numbers expected.\n"), "peaks", 1);
assert_checkerror("peaks(%i)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Must be greater than %d.\n"), "peaks", 1, 0);
assert_checkerror("peaks(-1)", msg);

[x, y, z] = peaks();
assert_checkequal(size(x), [49 49]);
assert_checkequal(size(y), [49 49]);
assert_checkequal(size(z), [49 49]);

[x, y, z] = peaks(2);
assert_checkequal(x, [-3 3 ; -3 3]);
assert_checkequal(y, [-3 -3 ; 3 3]);
assert_checkalmostequal(z, [0.0000667 -0.0000059 ; 0.0000322 0.000041], [], 4e-8);

[x, y, z] = peaks(1:2);
assert_checkequal(size(x), [2 2]);
assert_checkequal(size(y), [2 2]);
assert_checkequal(size(z), [2 2]);

[x, y, z] = peaks(1:2, 1:3);
assert_checkequal(size(x), [3 2]);
assert_checkequal(size(y), [3 2]);
assert_checkequal(size(z), [3 2]);
