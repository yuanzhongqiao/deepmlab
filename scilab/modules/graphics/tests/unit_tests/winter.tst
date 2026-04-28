// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

assert_checkerror("winter(0,1,2,3)", "Wrong number of input arguments.", 999);

assert_checkerror("winter(%t)", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "winter", 1);

assert_checkerror("winter(%i)", "%s: Wrong value for input argument #%d: Real numbers expected.\n", 999, "winter", 1);

assert_checkerror("winter([0 1 2 3])", "%s: Wrong size of input argument #%d: %d x %d expected.\n", 999, "winter", 1, 1, 1);

assert_checkequal(winter(0), []);

assert_checkequal(winter(1), [0 0 1]);

assert_checkequal(winter(2), [0 0 1;0 1 0.5]);

assert_checkequal(winter(3), [0 0 1;0 0.5 0.75;0 1 0.5]);
