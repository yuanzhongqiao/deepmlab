// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

assert_checkerror("ocean(0,1,2,3)", "Wrong number of input arguments.", 999);

assert_checkerror("ocean(%t)", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "ocean", 1);

assert_checkerror("ocean(%i)", "%s: Wrong value for input argument #%d: Real numbers expected.\n", 999, "ocean", 1);

assert_checkerror("ocean([0 1 2 3])", "%s: Wrong size of input argument #%d: %d x %d expected.\n", 999, "ocean", 1, 1, 1);

assert_checkequal(ocean(0), []);

assert_checkequal(ocean(1), [0 0.25 0.5]);

assert_checkalmostequal(ocean(2), [0 0 0.25;0.25 0.625 0.75]);

assert_checkalmostequal(ocean(3), [0 0 1/6;0 0.25 0.5;0.5 0.75 5/6]);
