// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

msg = msprintf(_("Wrong number of input arguments.\n"));
assert_checkerror("sphere(0, 1)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in ""double"".\n"), "sphere", 1);
assert_checkerror("sphere(""a"")", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Real numbers expected.\n"), "sphere", 1);
assert_checkerror("sphere(%i)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Non negative numbers expected.\n"), "sphere", 1);
assert_checkerror("sphere(-1)", msg);

[x, y, z] = sphere();
assert_checkequal(size(x), [21 21]);
assert_checkequal(size(y), [21 21]);
assert_checkequal(size(z), [21 21]);

[x, y, z] = sphere(0);
assert_checkalmostequal(x, 0, [], %eps);
assert_checkalmostequal(y, 0, [], %eps);
assert_checkequal(z, 1);

[x, y, z] = sphere(40);
assert_checkequal(size(x), [41 41]);
assert_checkequal(size(y), [41 41]);
assert_checkequal(size(z), [41 41]);

[x, y, z] = sphere([20, 40]);
assert_checkequal(size(x), [41 21]);
assert_checkequal(size(y), [41 21]);
assert_checkequal(size(z), [41 21]);
