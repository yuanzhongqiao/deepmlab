// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) Scilab Enterprises - 2015 - Juergen Koch <juergen.koch@hs-esslingen.de>
// 
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

assert_checkerror("parula(0,1,2,3)", "Wrong number of input arguments.", 999);

assert_checkerror("parula(%t)", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "parula", 1);

assert_checkerror("parula(%i)", "%s: Wrong value for input argument #%d: Real numbers expected.\n", 999, "parula", 1);

assert_checkerror("parula([0 1 2 3])", "%s: Wrong size of input argument #%d: %d x %d expected.\n", 999, "parula", 1, 1, 1);

assert_checkequal(parula(0), []);
