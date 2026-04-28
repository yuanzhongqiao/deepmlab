// =============================================================================
// Copyright (C) 2010 - 2012 - INRIA - Michael BAUDIN
// =============================================================================
// <-- CLI SHELL MODE -->
// =============================================================================
// <-- Non-regression test for bug 350 -->
//
// <-- Short Description -->
// The csvStringToDouble function always returns complex doubles.
// =============================================================================
path = SCI+"/modules/spreadsheet/tests/unit_tests/";

r = csvStringToDouble("12");
assert_checkequal ( isreal(r) , %t );
// =============================================================================

