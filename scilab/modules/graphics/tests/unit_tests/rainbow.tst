// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

assert_checkerror("rainbow(0,1,2,3)", "Wrong number of input arguments.", 999);

assert_checkerror("rainbow(%t)", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "rainbow", 1);

assert_checkerror("rainbow(%i)", "%s: Wrong value for input argument #%d: Real numbers expected.\n", 999, "rainbow", 1);

assert_checkerror("rainbow([0 1 2 3])", "%s: Wrong size of input argument #%d: %d x %d expected.\n", 999, "rainbow", 1, 1, 1);

assert_checkequal(rainbow(0), []);

assert_checkequal(rainbow(1), [0,1,0.5]);

assert_checkequal(rainbow(2), [0.75,1,0;0,0.25,1]);

assert_checkalmostequal(rainbow(3), [1,5/6,0;0,1,0.5;1/6,0,1]);
