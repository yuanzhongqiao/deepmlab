// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

assert_checkerror("white(0,1,2,3)", "Wrong number of input arguments.", 999);

assert_checkerror("white(%t)", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "white", 1);

assert_checkerror("white(%i)", "%s: Wrong value for input argument #%d: Real numbers expected.\n", 999, "white", 1);

assert_checkerror("white([0 1 2 3])", "%s: Wrong size of input argument #%d: %d x %d expected.\n", 999, "white", 1, 1, 1);

assert_checkequal(white(0), []);

assert_checkequal(white(1), ones(1,3));

assert_checkequal(white(2), ones(2,3));

assert_checkequal(white(3), ones(3,3));
