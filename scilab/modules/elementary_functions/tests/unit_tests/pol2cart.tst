// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

[x, y, z] = pol2cart([], [], []);
assert_checkequal(x, []);
assert_checkequal(y, []);
assert_checkequal(z, []);

[x, y] = pol2cart(0:%pi/4:%pi, 1:5);
assert_checkalmostequal(x, [1 sqrt(2) 0 -sqrt(2)*2 -5], [], %eps);
assert_checkalmostequal(y, [0 sqrt(2) 3 sqrt(2)*2 0], [], 3*%eps);

[x, y, z] = pol2cart(0:%pi/4:%pi, 1:5, 2);
assert_checkalmostequal(x, [1 sqrt(2) 0 -sqrt(2)*2 -5], [], %eps);
assert_checkalmostequal(y, [0 sqrt(2) 3 sqrt(2)*2 0], [], 3*%eps);
assert_checkequal(z, [2 2 2 2 2]);

[x, y, z] = pol2cart(0:%pi/4:%pi, 1:5, 2:6);
assert_checkalmostequal(x, [1 sqrt(2) 0 -sqrt(2)*2 -5], [], %eps);
assert_checkalmostequal(y, [0 sqrt(2) 3 sqrt(2)*2 0], [], 3*%eps);
assert_checkequal(z, [2 3 4 5 6]);

msg = msprintf(_("%s: Wrong number of input arguments: %d to %d expected.\n"), "pol2cart", 2, 3);
assert_checkerror("pol2cart()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "pol2cart", 1, sci2exp("double"));
assert_checkerror("pol2cart(""a"", ""b"", ""c"")", msg);
msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "pol2cart", 2, sci2exp("double"));
assert_checkerror("pol2cart(0, ""b"", ""c"")", msg);
msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "pol2cart", 3, sci2exp("double"));
assert_checkerror("pol2cart(0, 0, ""c"")", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Real numbers expected.\n"), "pol2cart", 1);
assert_checkerror("pol2cart(%i, 0, 0)", msg);
msg = msprintf(_("%s: Wrong value for input argument #%d: Real numbers expected.\n"), "pol2cart", 2);
assert_checkerror("pol2cart(0, %i, 0)", msg);
msg = msprintf(_("%s: Wrong value for input argument #%d: Real numbers expected.\n"), "pol2cart", 3);
assert_checkerror("pol2cart(0, 0, %i)", msg);

msg = msprintf(_("%s: Wrong size for input argument #%d: Must be of the same dimensions of #%d.\n"), "pol2cart", 1, 2);
assert_checkerror("pol2cart(0, 1:2)", msg);
msg = msprintf(_("%s: Wrong size for input argument #%d: Must be a scalar or be of the same dimensions as #%d.\n"), "pol2cart", 3, 1);
assert_checkerror("pol2cart(0, 0, 1:2)", msg);
