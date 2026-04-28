// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

assert_checkerror("pink(0,1,2,3)", "Wrong number of input arguments.", 999);

assert_checkerror("pink(%t)", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "pink", 1);

assert_checkerror("pink(%i)", "%s: Wrong value for input argument #%d: Real numbers expected.\n", 999, "pink", 1);

assert_checkerror("pink([0 1 2 3])", "%s: Wrong size of input argument #%d: %d x %d expected.\n", 999, "pink", 1, 1, 1);

assert_checkequal(pink(0), []);

assert_checkalmostequal(pink(1), [0.5773503,0.5773503,0.5773503], 1e-7);

assert_checkalmostequal(pink(2), [0.5773503,0.5773503,0.4082483;1,1,1], 1e-7);

assert_checkalmostequal(pink(3), [0.5773503,0,0;0.8164966,0.8164966,0.5773503;1,1,1], 1e-7);
