// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

assert_checkerror("summer(0,1,2,3)", "Wrong number of input arguments.", 999);

assert_checkerror("summer(%t)", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "summer", 1);

assert_checkerror("summer(%i)", "%s: Wrong value for input argument #%d: Real numbers expected.\n", 999, "summer", 1);

assert_checkerror("summer([0 1 2 3])", "%s: Wrong size of input argument #%d: %d x %d expected.\n", 999, "summer", 1, 1, 1);

assert_checkequal(summer(0), []);

assert_checkequal(summer(1), [0 0.5 0.4]);

assert_checkequal(summer(2), [0 0.5 0.4;1 1 0.4]);

assert_checkequal(summer(3), [0 0.5 0.4;0.5 0.75 0.4;1 1 0.4]);
