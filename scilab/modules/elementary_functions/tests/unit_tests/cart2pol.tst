// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

[theta, rho, z] = cart2pol([], [], []);
assert_checkequal(theta, []);
assert_checkequal(rho, []);
assert_checkequal(z, []);

[theta, rho] = cart2pol([0 2 4 0], [0 2 0 4]);
assert_checkequal(theta, [0 %pi/4 0 %pi/2]);
assert_checkequal(rho, [0 sqrt(8) 4 4]);

[theta, rho, z] = cart2pol([0 2 4 0], [0 2 0 4], 2);
assert_checkequal(theta, [0 %pi/4 0 %pi/2]);
assert_checkequal(rho, [0 sqrt(8) 4 4]);
assert_checkequal(z, [2 2 2 2]);

[theta, rho, z] = cart2pol([0 2 4 0], [0 2 0 4], 2:5);
assert_checkequal(theta, [0 %pi/4 0 %pi/2]);
assert_checkequal(rho, [0 sqrt(8) 4 4]);
assert_checkequal(z, [2 3 4 5]);

msg = msprintf(_("%s: Wrong number of input arguments: %d to %d expected.\n"), "cart2pol", 2, 3);
assert_checkerror("cart2pol()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "cart2pol", 1, sci2exp("double"));
assert_checkerror("cart2pol(""a"", ""b"", ""c"")", msg);
msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "cart2pol", 2, sci2exp("double"));
assert_checkerror("cart2pol(0, ""b"", ""c"")", msg);
msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "cart2pol", 3, sci2exp("double"));
assert_checkerror("cart2pol(0, 0, ""c"")", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Real numbers expected.\n"), "cart2pol", 1);
assert_checkerror("cart2pol(%i, 0, 0)", msg);
msg = msprintf(_("%s: Wrong value for input argument #%d: Real numbers expected.\n"), "cart2pol", 2);
assert_checkerror("cart2pol(0, %i, 0)", msg);
msg = msprintf(_("%s: Wrong value for input argument #%d: Real numbers expected.\n"), "cart2pol", 3);
assert_checkerror("cart2pol(0, 0, %i)", msg);

msg = msprintf(_("%s: Wrong size for input argument #%d: Must be of the same dimensions of #%d.\n"), "cart2pol", 1, 2);
assert_checkerror("cart2pol(0, 1:2)", msg);
msg = msprintf(_("%s: Wrong size for input argument #%d: Must be a scalar or be of the same dimensions as #%d.\n"), "cart2pol", 3, 1);
assert_checkerror("cart2pol(0, 0, 1:2)", msg);
