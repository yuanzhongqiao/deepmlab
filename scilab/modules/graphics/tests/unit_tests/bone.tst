// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

assert_checkerror("bone(0,1,2,3)", "Wrong number of input arguments.", 999);

assert_checkerror("bone(%t)", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "bone", 1);

assert_checkerror("bone(%i)", "%s: Wrong value for input argument #%d: Real numbers expected.\n", 999, "bone", 1);

assert_checkerror("bone([0 1 2 3])", "%s: Wrong size of input argument #%d: %d x %d expected.\n", 999, "bone", 1, 1, 1);

assert_checkequal(bone(0), []);

assert_checkequal(bone(1), [0.125 0.125 0.125]);

assert_checkequal(bone(2), [0.0625 0.125 0.125;1 1 1]);

assert_checkequal(bone(3), [0 0 0.125;0.4375 0.5625 0.5625;1 1 1]);
