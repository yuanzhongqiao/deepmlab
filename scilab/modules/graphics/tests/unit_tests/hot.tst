// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

assert_checkerror("hot(0,1,2,3)", "Wrong number of input arguments.", 999);

assert_checkerror("hot(%t)", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "hot", 1);

assert_checkerror("hot(%i)", "%s: Wrong value for input argument #%d: Real numbers expected.\n", 999, "hot", 1);

assert_checkerror("hot([0 1 2 3])", "%s: Wrong size of input argument #%d: %d x %d expected.\n", 999, "hot", 1, 1, 1);

assert_checkequal(hot(0), []);

assert_checkequal(hot(1), [1 1 1]);

assert_checkequal(hot(2), [1 1 0.5;1 1 1]);

assert_checkequal(hot(3), [1 0 0;1 1 0;1 1 1]);
