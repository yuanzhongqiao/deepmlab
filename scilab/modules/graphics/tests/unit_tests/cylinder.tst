// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

msg = msprintf(_("Wrong number of input arguments.\n"));
assert_checkerror("cylinder(0, 1, 2)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in ""double"".\n"), "cylinder", 1);
assert_checkerror("cylinder(""a"")", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Real numbers expected.\n"), "cylinder", 1);
assert_checkerror("cylinder(%i)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Non negative numbers expected.\n"), "cylinder", 1);
assert_checkerror("cylinder(-1)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be a vector.\n"), "cylinder", 1);
assert_checkerror("cylinder(ones(2,2))", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in ""double"".\n"), "cylinder", 2);
assert_checkerror("cylinder(1, ""a"")", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Real numbers expected.\n"), "cylinder", 2);
assert_checkerror("cylinder(1, %i)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Non negative numbers expected.\n"), "cylinder", 2);
assert_checkerror("cylinder(1, -1)", msg);

[x, y, z] = cylinder();
assert_checkequal(size(x), [2 21]);
assert_checkequal(max(x), 1);
assert_checkequal(min(x), -1);
assert_checkequal(size(y), [2 21]);
assert_checkequal(size(z), [2 21]);
assert_checkequal(max(y), 1);
assert_checkequal(min(y), -1);
assert_checkequal(z, [zeros(1,21) ; ones(1,21)]);

[x, y, z] = cylinder(40);
assert_checkequal(max(x), 40);
assert_checkequal(min(x), -40);
assert_checkequal(max(y), 40);
assert_checkequal(min(y), -40);
assert_checkequal(z, [zeros(1,21) ; ones(1,21)]);

[x, y, z] = cylinder(40, 50);
assert_checkequal(size(x), [2 51]);
assert_checkequal(size(y), [2 51]);
assert_checkequal(z, [zeros(1,51) ; ones(1,51)]);