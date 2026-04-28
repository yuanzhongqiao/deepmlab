// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

assert_checkerror("copper(0,1,2,3)", "Wrong number of input arguments.", 999);

assert_checkerror("copper(%t)", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "copper", 1);

assert_checkerror("copper(%i)", "%s: Wrong value for input argument #%d: Real numbers expected.\n", 999, "copper", 1);

assert_checkerror("copper([0 1 2 3])", "%s: Wrong size of input argument #%d: %d x %d expected.\n", 999, "copper", 1, 1, 1);

assert_checkequal(copper(0), []);

assert_checkequal(copper(1), [1 0.8 0.5]);

assert_checkequal(copper(2), [0 0 0;1 0.8 0.5]);

assert_checkequal(copper(3), [0 0 0;0.625 0.4 0.25;1 0.8 0.5]);
