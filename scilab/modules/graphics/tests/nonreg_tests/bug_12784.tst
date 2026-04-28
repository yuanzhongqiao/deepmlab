// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- NO CHECK REF -->

// <-- Non-regression test for bug 12784 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12784
//
// <-- Short Description -->
//    Misleading error message in many functions when passing an integer 
//    argument instead of double argument.
// =============================================================================

assert_checkerror("autumn(uint8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "autumn", 1);
assert_checkerror("autumn(int8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "autumn", 1);

assert_checkerror("bone(uint8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "bone", 1);
assert_checkerror("bone(int8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "bone", 1);

assert_checkerror("cool(uint8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "cool", 1);
assert_checkerror("cool(int8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "cool", 1);

assert_checkerror("copper(uint8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "copper", 1);
assert_checkerror("copper(int8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "copper", 1);

assert_checkerror("gray(uint8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "gray", 1);
assert_checkerror("gray(int8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "gray", 1);

assert_checkerror("hot(uint8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "hot", 1);
assert_checkerror("hot(int8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "hot", 1);

assert_checkerror("hsv(uint8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "hsv", 1);
assert_checkerror("hsv(int8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "hsv", 1);

assert_checkerror("jet(uint8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "jet", 1);
assert_checkerror("jet(int8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "jet", 1);

assert_checkerror("ocean(uint8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "ocean", 1);
assert_checkerror("ocean(int8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "ocean", 1);

assert_checkerror("pink(uint8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "pink", 1);
assert_checkerror("pink(int8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "pink", 1);

assert_checkerror("rainbow(uint8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "rainbow", 1);
assert_checkerror("rainbow(int8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "rainbow", 1);

assert_checkerror("spring(uint8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "spring", 1);
assert_checkerror("spring(int8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "spring", 1);

assert_checkerror("summer(uint8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "summer", 1);
assert_checkerror("summer(int8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "summer", 1);

assert_checkerror("white(uint8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "white", 1);
assert_checkerror("white(int8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "white", 1);

assert_checkerror("winter(uint8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "winter", 1);
assert_checkerror("winter(int8(1))", "%s: Wrong type for input argument #%d: Must be in ""double"".\n", 999, "winter", 1);
